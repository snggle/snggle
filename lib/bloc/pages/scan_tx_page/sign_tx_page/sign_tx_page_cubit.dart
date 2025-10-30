import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/a_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/transaction_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class SignTxPageCubit extends Cubit<ASignTxPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final TransactionsService _transactionsService = globalLocator<TransactionsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final ActiveWalletController _activeWalletController = globalLocator<ActiveWalletController>();

  final CborEthSignRequest _cborEthSignRequest;

  late final WalletModel senderWalletModel;
  late final TransactionModel transactionModel;
  late final String? senderWalletAddress;
  late final PasswordModel _senderWalletPasswordModel;

  SignTxPageCubit({
    required CborEthSignRequest cborEthSignRequest,
  })  : _cborEthSignRequest = cborEthSignRequest,
        super(const SignTxPageConfirmTxState());

  Future<void> init() async {
    senderWalletAddress = _activeWalletController.walletModel?.address ?? _cborEthSignRequest.address?.toLowerCase();
    print('SIGNER ADDRESS: $senderWalletAddress');

    await _setupSignWallet();
    transactionModel = TransactionModel.fromCborEthSignRequest(senderWalletModel.id, senderWalletAddress, _cborEthSignRequest);
  }

  Future<void> signTransaction() async {
    WalletSecretsModel walletSecretsModel = await _secretsService.get(senderWalletModel.filesystemPath, _senderWalletPasswordModel);

    ECPrivateKey ecPrivateKey = ECPrivateKey.fromBytes(walletSecretsModel.privateKey, CurvePoints.generatorSecp256k1);
    AEthereumTransaction ethereumTransaction = AEthereumTransaction.fromSerializedData(transactionModel.signDataType, _cborEthSignRequest.signData);

    ASignature signature = ethereumTransaction.sign(ecPrivateKey);
    TransactionModel signedTransactionModel = transactionModel.addSignature(signature.hex);
    await _transactionsService.save(signedTransactionModel);

    CborEthSignature cborEthSignature = CborEthSignature(
      signature: signature.bytes,
      origin: _cborEthSignRequest.origin,
      requestId: _cborEthSignRequest.requestId ?? Uint8List(0),
    );

    print('SIGNATURE');
    print('requestId: ${cborEthSignature.requestId}');
    print('signature: ${cborEthSignature.signature}');
    print('origin: ${cborEthSignature.origin}');

    emit(SignTxPageSignedTxState(
      transactionModel: signedTransactionModel,
      cborEthSignature: cborEthSignature,
    ));
  }

  Future<void> _setupSignWallet() async {
    if (senderWalletAddress == null) {
      throw const ScanQrException(ScanQrExceptionType.receivedAddressEmpty);
    }

    senderWalletModel = await _getWalletFromDatabase(senderWalletAddress!);
    _senderWalletPasswordModel = await _getPasswordForWallet(senderWalletModel);
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
      // TODO(dominik): Exception may be replaced with a UI dialog to enter the password
      throw const ScanQrException(ScanQrExceptionType.walletWithEncryptedParents);
    }
  }
}
