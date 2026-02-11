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
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception.dart';
import 'package:snggle/shared/exceptions/scan_qr_exception_type.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/transactions/transaction_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class SignTxPageCubit extends Cubit<ASignTxPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();
  final TransactionsService _transactionsService = globalLocator<TransactionsService>();
  final VaultsService _vaultsService = globalLocator<VaultsService>();
  final WalletsService _walletsService = globalLocator<WalletsService>();

  final bool _walletAutoDetectionEnabledBool;
  final CborEthSignRequest _cborEthSignRequest;

  late final TransactionModel transactionModel;
  late final WalletModel senderWalletModel;
  late final PasswordModel _senderWalletPasswordModel;

  SignTxPageCubit({
    required bool walletAutoDetectionEnabledBool,
    required CborEthSignRequest cborEthSignRequest,
  })  : _walletAutoDetectionEnabledBool = walletAutoDetectionEnabledBool,
        _cborEthSignRequest = cborEthSignRequest,
        super(const SignTxPageConfirmTxState());

  Future<void> init() async {
    senderWalletModel = await _determineSenderWalletModel();

    _senderWalletPasswordModel = await _getPasswordForWallet(senderWalletModel);
    transactionModel = TransactionModel.fromCborEthSignRequest(
      senderWalletModel.id,
      senderWalletModel.address,
      _cborEthSignRequest,
    );
  }

  Future<void> signTransaction() async {
    WalletSecretsModel walletSecretsModel = await _secretsService.get(senderWalletModel.filesystemPath, _senderWalletPasswordModel);

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

  Future<WalletModel> _determineSenderWalletModel() async {
    if (_walletAutoDetectionEnabledBool == false) {
      return _getActiveWallet();
    }

    if (_cborEthSignRequest.address != null) {
      return _getWalletBySenderAddress(_cborEthSignRequest.address!);
    }

    if (_cborEthSignRequest.derivationPath.sourceFingerprint != null) {
      return _getWalletByFingerprint(_cborEthSignRequest.derivationPath.sourceFingerprint!);
    }

    throw const ScanQrException(ScanQrExceptionType.receivedAddressEmpty);
  }

  Future<WalletModel> _getActiveWallet() {
    String address = globalLocator<ActiveWalletController>().walletModel!.address;
    return _walletsService.getByAddress(address);
  }

  Future<WalletModel> _getWalletBySenderAddress(String senderAddress) {
    return _walletsService.getByAddress(senderAddress);
  }

  Future<WalletModel> _getWalletByFingerprint(int fingerprint) async {
    VaultModel matchingVault = await _findMatchingVault(fingerprint);

    String derivationPath = _convertDerivationPathToString(
      _cborEthSignRequest.derivationPath.components,
    );

    return _findMatchingWalletInVault(matchingVault, derivationPath);
  }

  Future<VaultModel> _findMatchingVault(int sourceFingerprint) async {
    FilesystemPath emptyRootPath = FilesystemPath.fromString('');
    List<VaultModel> allVaultModels = await _vaultsService.getAllByParentPath(emptyRootPath);

    return allVaultModels.firstWhere(
      (VaultModel vaultModel) => vaultModel.fingerprint == sourceFingerprint.toString(),
      orElse: () => throw const ScanQrException(ScanQrExceptionType.vaultNotFound),
    );
  }

  // TODO(marcin): Optional extraction of derivation path conversion to codec_utils library
  String _convertDerivationPathToString(List<CborPathComponent> cborPathComponents) {
    String path = cborPathComponents.map((CborPathComponent component) {
      String formattedIndex = component.hardened ? "${component.index}'" : '${component.index}';
      return formattedIndex;
    }).join('/');

    return 'm/$path';
  }

  Future<WalletModel> _findMatchingWalletInVault(VaultModel vaultModel, String derivationPath) async {
    List<WalletModel> walletModelList = await _walletsService.getAllByParentPath(vaultModel.filesystemPath);

    return walletModelList.firstWhere(
      (WalletModel walletModel) => walletModel.derivationPath == derivationPath,
      orElse: () => throw const ScanQrException(ScanQrExceptionType.walletNotFound),
    );
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
