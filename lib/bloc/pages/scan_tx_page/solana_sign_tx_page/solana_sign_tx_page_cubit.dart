import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/a_solana_sign_tx_page_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/states/solana_sign_tx_page_confirm_tx_state.dart';
import 'package:snggle/bloc/pages/scan_tx_page/solana_sign_tx_page/states/solana_sign_tx_page_signed_tx_state.dart';
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
import 'package:snggle/shared/models/transactions/solana_transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class SolanaSignTxPageCubit extends Cubit<ASolanaSignTxPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final TransactionsService _transactionsService = globalLocator<TransactionsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final ActiveWalletController _activeWalletController = globalLocator<ActiveWalletController>();

  final CborSolSignRequest _cborSolSignRequest;

  late final PasswordModel _signWalletPasswordModel;
  late final WalletModel signWalletModel;
  late final SolanaTransactionModel transactionModel;

  SolanaSignTxPageCubit({
    required CborSolSignRequest cborSolSignRequest,
  })  : _cborSolSignRequest = cborSolSignRequest,
        super(const SolanaSignTxPageConfirmTxState());

  Future<void> init() async {
    await _setupSignWallet();
    transactionModel = SolanaTransactionModel.fromCborSolSignRequest(signWalletModel.id, _cborSolSignRequest);
  }

  Future<void> signTransaction() async {
    WalletSecretsModel walletSecretsModel = await _secretsService.get(signWalletModel.filesystemPath, _signWalletPasswordModel);

    EDPrivateKey edPrivateKey = EDPrivateKey.fromBytes(walletSecretsModel.privateKey);

    ED25519PrivateKey ed25519PrivateKey = ED25519PrivateKey(
      edPrivateKey: edPrivateKey,
      metadata: Bip32KeyMetadata.fromCompressedPublicKey(compressedPublicKey: edPrivateKey.edPublicKey.bytes),
    );

    Uint8List message = _cborSolSignRequest.signData;
    ASignature signature = SolanaSigner(ed25519PrivateKey).sign(message);

    String signatureHex = HexCodec.encode(signature.bytes);

    SolanaTransactionModel signedTransactionModel = transactionModel.addSignature(signatureHex);
    await _transactionsService.save(signedTransactionModel);

    emit(SolanaSignTxPageSignedTxState(
      transactionModel: signedTransactionModel,
      cborSolSignature: CborSolSignature(
        signature: signature.bytes,
        requestId: _cborSolSignRequest.requestId ?? Uint8List(0),
      ),
    ));
  }

  Future<void> _setupSignWallet() async {
    String? receivedWalletAddress = _cborSolSignRequest.address?.toString().toLowerCase() ?? _activeWalletController.walletModel?.address;

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
      // TODO(dominik): Exception may be replaced with a UI dialog to enter the password
      throw const ScanQrException(ScanQrExceptionType.walletWithEncryptedParents);
    }
  }
}
