import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/ethereum_sign_tx_page/a_ethereum_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/ethereum_sign_tx_page/states/ethereum_sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/ethereum_sign_tx_page/states/ethereum_sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/exceptions/child_key_not_found_exception.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/transaction_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class EthereumSignTxPageCubit extends Cubit<AEthereumSignTxPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final TransactionsService _transactionsService =
      globalLocator<TransactionsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();

  final CborEthSignRequest _cborEthSignRequest;

  late final PasswordModel _signWalletPasswordModel;
  late final WalletModel signWalletModel;
  late final EthereumTransactionModel transactionModel;

  EthereumSignTxPageCubit({
    required CborEthSignRequest cborEthSignRequest,
  })  : _cborEthSignRequest = cborEthSignRequest,
        super(const EthereumSignTxPageConfirmTxState());

  Future<void> init() async {
    await _setupSignWallet();
    transactionModel = EthereumTransactionModel.fromCborEthSignRequest(
        signWalletModel.id, _cborEthSignRequest);
  }

  Future<void> signTransaction() async {
    WalletSecretsModel walletSecretsModel = await _secretsService.get(
        signWalletModel.filesystemPath, _signWalletPasswordModel);

    ECPrivateKey ecPrivateKey = ECPrivateKey.fromBytes(
        walletSecretsModel.privateKey, CurvePoints.generatorSecp256k1);
    AEthereumTransaction ethereumTransaction =
        AEthereumTransaction.fromSerializedData(
            transactionModel.signDataType, _cborEthSignRequest.signData);

    ASignature signature = ethereumTransaction.sign(ecPrivateKey);
    EthereumTransactionModel signedTransactionModel =
        transactionModel.addSignature(signature.hex);
    await _transactionsService.save(signedTransactionModel);

    emit(EthereumSignTxPageSignedTxState(
      transactionModel: signedTransactionModel,
      cborEthSignature: CborEthSignature(
        signature: signature.bytes,
        origin: _cborEthSignRequest.origin,
        requestId: _cborEthSignRequest.requestId ?? Uint8List(0),
      ),
    ));
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
      return await globalLocator<PasswordController>()
          .getPasswordByFilesystemPath(walletModel.filesystemPath);
    } catch (_) {
      // TODO(dominik): Exception may be replaced with a UI dialog to enter the password
      throw const ScanQrException(
          ScanQrExceptionType.walletWithEncryptedParents);
    }
  }
}
