import 'dart:async';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/a_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_enter_passwords_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/services/groups_service.dart';
import 'package:snggle/infra/services/i_list_items_service.dart';
import 'package:snggle/infra/services/network_groups_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/transaction_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class SignTxPageCubit extends Cubit<ASignTxPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final TransactionsService _transactionsService = globalLocator<TransactionsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final Completer<List<String>> completer = Completer<List<String>>();

  final CborEthSignRequest _cborEthSignRequest;

  late final PasswordModel _signWalletPasswordModel;
  late final WalletModel signWalletModel;
  late final TransactionModel transactionModel;

  SignTxPageCubit({
    required CborEthSignRequest cborEthSignRequest,
  })  : _cborEthSignRequest = cborEthSignRequest,
        super(const SignTxPageConfirmTxState());

  Future<void> init() async {
    await _setupSignWallet();
    transactionModel = TransactionModel.fromCborEthSignRequest(signWalletModel.id, _cborEthSignRequest);
  }

  Future<void> signTransaction() async {
    WalletSecretsModel walletSecretsModel = await _secretsService.get(signWalletModel.filesystemPath, _signWalletPasswordModel);

    ECPrivateKey ecPrivateKey = ECPrivateKey.fromBytes(walletSecretsModel.privateKey, CurvePoints.generatorSecp256k1);
    AEthereumTransaction ethereumTransaction = AEthereumTransaction.fromSerializedData(transactionModel.signDataType, _cborEthSignRequest.signData);

    ASignature signature = ethereumTransaction.sign(ecPrivateKey);
    TransactionModel signedTransactionModel = transactionModel.addSignature(signature.hex);
    await _transactionsService.save(signedTransactionModel);

    emit(SignTxPageSignedTxState(
      transactionModel: signedTransactionModel,
      cborEthSignature: CborEthSignature(
        signature: signature.bytes,
        origin: _cborEthSignRequest.origin,
        requestId: _cborEthSignRequest.requestId ?? Uint8List(0),
      ),
    ));
  }

  void accept() {
    for (AListItemModel listItemModel in (state as SignTxPageEnterPasswordsState).listItemModels.reversed) {
      globalLocator<PasswordController>().removeByFilesystemPath(listItemModel.filesystemPath);
    }
    emit(const SignTxPageConfirmTxState());
  }

  Future<void> _setupSignWallet() async {
    String? receivedWalletAddress = _cborEthSignRequest.address?.toLowerCase();

    if (receivedWalletAddress == null) {
      throw const ScanQrException(ScanQrExceptionType.receivedAddressEmpty);
    }

    signWalletModel = await _getWalletFromDatabase(receivedWalletAddress);
    _signWalletPasswordModel = await _getPasswordForWallet(signWalletModel);
  }

  Future<WalletModel> _getWalletFromDatabase(String signWalletAddress) async {
    try {
      return await _walletsService.getByAddress(signWalletAddress);
    } on ChildKeyNotFoundException catch (_) {
      throw const ScanQrException(ScanQrExceptionType.walletNotFound);
    }
  }

  Future<PasswordModel> _getPasswordForWallet(WalletModel walletModel) async {
    try {
      return await globalLocator<PasswordController>().getPasswordByFilesystemPath(walletModel.filesystemPath);
    } catch (_) {
      List<FilesystemPath> lockedParentPaths = await globalLocator<PasswordController>().getLockedParentPaths(walletModel.filesystemPath);
      List<AListItemModel> elements = <AListItemModel>[];
      for (FilesystemPath filesystemPath in lockedParentPaths) {
        AListItemModel element = await _getByPath(filesystemPath);
        elements.add(element);
      }

      emit(SignTxPageEnterPasswordsState(listItemModels: elements.reversed.toList()));
      return PasswordModel.defaultPassword();
    }
  }

  Future<AListItemModel> _getByPath(FilesystemPath filesystemPath) async {
    final List<IListItemsService<AListItemModel>> services = <IListItemsService<AListItemModel>>[
      globalLocator<GroupsService>(),
      globalLocator<VaultsService>(),
      globalLocator<NetworkGroupsService>(),
      _walletsService,
    ];

    for (final IListItemsService<AListItemModel> service in services) {
      try {
        return await service.getByPath(filesystemPath);
      } catch (_) {}
    }

    throw Exception('Could not find ${filesystemPath} in the ISAR database');
  }
}
