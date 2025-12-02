import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/a_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_signed_tx_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/transaction_service.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class SignTxPageCubit extends Cubit<ASignTxPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final TransactionsService _transactionsService = globalLocator<TransactionsService>();
  final ActiveWalletController _activeWalletController = globalLocator<ActiveWalletController>();

  final CborEthSignRequest _cborEthSignRequest;

  late final WalletModel activeWalletModel;
  late final TransactionModel transactionModel;

  SignTxPageCubit({
    required CborEthSignRequest cborEthSignRequest,
  })  : _cborEthSignRequest = cborEthSignRequest,
        super(const SignTxPageConfirmTxState());

  Future<void> init() async {
    assert(
      _activeWalletController.walletModel?.address != null,
      'Wallet must be opened before initializing SignTxPageCubit',
    );

    activeWalletModel = _activeWalletController.walletModel!;
    transactionModel = TransactionModel.fromCborEthSignRequest(activeWalletModel.id, activeWalletModel.address, _cborEthSignRequest);
  }

  Future<void> signTransaction() async {
    WalletSecretsModel walletSecretsModel = await _secretsService.get(activeWalletModel.filesystemPath, PasswordModel.defaultPassword());

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
}
