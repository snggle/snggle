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
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/transactions/ethereum_transaction_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

class EthereumSignTxPageCubit extends Cubit<AEthereumSignTxPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final TransactionsService _transactionsService = globalLocator<TransactionsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();
  final ActiveWalletController _activeWalletController = globalLocator<ActiveWalletController>();

  final CborEthSignRequest _cborEthSignRequest;

  late final PasswordModel _signWalletPasswordModel;
  late final WalletModel signWalletModel;
  late final TransactionModel transactionModel;

  EthereumSignTxPageCubit({
    required CborEthSignRequest cborEthSignRequest,
  })  : _cborEthSignRequest = cborEthSignRequest,
        super(const EthereumSignTxPageConfirmTxState());

  Future<void> init() async {
    await _setupSignWallet();
    transactionModel = TransactionModel.fromCborSolSignRequest(signWalletModel.id); //, _cborSolSignRequest);
  }

  Future<void> signTransaction() async {
    WalletSecretsModel walletSecretsModel = await _secretsService.get(
      signWalletModel.filesystemPath,
      _signWalletPasswordModel,
    );

    print('--- Raw Sign Data ---');
    print(_cborEthSignRequest.signData);

    //SolanaTransaction solanaTransaction = SolanaTransaction.fromSerializedData(_cborSolSignRequest.signData);
    SolanaMessage solanaMessage = SolanaMessage.fromBytes(_cborEthSignRequest.signData);

    print('--- Solana Message ---');
    print('Recent Blockhash: ${Base58Codec.encode(solanaMessage.recentBlockhash)}');

    for (int i = 0; i < solanaMessage.accountKeys.length; i++) {
      print('Account $i: ${Base58Codec.encode(solanaMessage.accountKeys[i])}');
    }

    for (int i = 0; i < solanaMessage.instructions.length; i++) {
      final SolanaInstruction instruction = solanaMessage.instructions[i];
      print('--- Instruction #$i ---');

      final int programIdIndex = instruction.programIdIndex;
      final String programId = Base58Codec.encode(solanaMessage.accountKeys[programIdIndex]);
      print('Program ID Index: $programIdIndex => $programId');
      print('Account Indices: ${instruction.accountIndices}');
      print('Raw Data: ${instruction.data}');
      print('Account Keys: $solanaMessage.accountKeys');
      final DecodedInstruction decoded = instruction.decode(solanaMessage.accountKeys);

      print('Decoded Instruction:');
      print('  Type: ${decoded.type}');
      print('  Program ID: ${decoded.programId}');
      if (decoded.error != null) {
        print('  Error: ${decoded.error}');
        continue;
      }

      decoded.printDecoded();
    }

    EDPrivateKey edPrivateKey = EDPrivateKey.fromBytes(walletSecretsModel.privateKey);

    ED25519PrivateKey ed25519PrivateKey = ED25519PrivateKey(
      edPrivateKey: edPrivateKey,
      metadata: Bip32KeyMetadata.fromCompressedPublicKey(
        compressedPublicKey: edPrivateKey.edPublicKey.bytes,
      ),
    );

    SolanaSigner signer = SolanaSigner(ed25519PrivateKey);

    Uint8List message = _cborEthSignRequest.signData;
    SolanaSignature signature = signer.sign(message);
    //ASignature signature = solanaTransaction.sign(ed25519PrivateKey, message);

    String signatureHex = HexCodec.encode(signature.bytes);

    TransactionModel signedTransactionModel = transactionModel.addSignature(signatureHex);
    await _transactionsService.save(signedTransactionModel);

    emit(EthereumSignTxPageSignedTxState(
      transactionModel: signedTransactionModel,
      cborEthSignature: CborEthSignature(
        signature: signature.bytes,
        requestId: _cborEthSignRequest.requestId ?? Uint8List(0),
      ),
    ));
  }

  Future<void> _setupSignWallet() async {
    String? receivedWalletAddress = _cborEthSignRequest.address?.toString().toLowerCase() ?? _activeWalletController.walletModel?.address;

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
