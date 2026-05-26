import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_connect_option.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletConnectPageCubit extends Cubit<WalletConnectPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();

  final VaultModel _vaultModel;
  final WalletModel _walletModel;

  WalletConnectPageCubit({
    required this._vaultModel,
    required this._walletModel,
  }) : super(const WalletConnectPageState());

  void changeConnectOption(WalletConnectOption walletConnectOption) {
    emit(WalletConnectPageState(walletConnectOption: walletConnectOption));
  }

  Future<CborCryptoHDKey> getCborCryptoHDKey({required int derivationPathDepth}) async {
    Secp256k1Derivator secp256k1Derivator = Secp256k1Derivator();
    LegacyDerivationPath legacyDerivationPath = LegacyDerivationPath.parse(_walletModel.derivationPath);

    List<LegacyDerivationPathElement> parentPathElements = legacyDerivationPath.pathElements.sublist(
      0,
      derivationPathDepth,
    );

    PasswordModel vaultPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(_vaultModel.filesystemPath);
    VaultSecretsModel vaultSecretsModel = await _secretsService.get<VaultSecretsModel>(_vaultModel.filesystemPath, vaultPasswordModel);
    Secp256k1PrivateKey secp256k1PrivateKey = await secp256k1Derivator.derivePath(
      Mnemonic(vaultSecretsModel.mnemonicModel.mnemonicList),
      LegacyDerivationPath(pathElements: parentPathElements),
    );

    CborCryptoKeypath cborCryptoKeypath = CborCryptoKeypath(
      components: parentPathElements.map((LegacyDerivationPathElement e) {
        return CborPathComponent(index: e.rawIndex, hardened: e.isHardened);
      }).toList(),
      depth: parentPathElements.length,
      sourceFingerprint: secp256k1PrivateKey.metadata.fingerprint.toInt(),
    );

    return CborCryptoHDKey(
      isMaster: false,
      isPrivate: false,
      keyData: secp256k1PrivateKey.publicKey.compressed,
      chainCode: secp256k1PrivateKey.metadata.chainCode,
      origin: cborCryptoKeypath,
      parentFingerprint: secp256k1PrivateKey.metadata.parentFingerprint?.toInt(),
      name: _walletModel.name,
    );
  }

  Future<CborCryptoMultiAccounts> getCborCryptoMultiAccounts() async {
    LegacyDerivationPath derivationPath = LegacyDerivationPath.parse(_walletModel.derivationPath);

    PasswordModel vaultPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(_vaultModel.filesystemPath);

    VaultSecretsModel vaultSecretsModel = await _secretsService.get<VaultSecretsModel>(
      _vaultModel.filesystemPath,
      vaultPasswordModel,
    );

    ED25519Derivator ed25519Derivator = ED25519Derivator();
    ED25519PrivateKey ed25519PrivateKey = await ed25519Derivator.derivePath(
      Mnemonic(vaultSecretsModel.mnemonicModel.mnemonicList),
      derivationPath,
    );

    CborCryptoKeypath cborCryptoKeypath = CborCryptoKeypath(
      components: derivationPath
          .pathElements //
          .map((LegacyDerivationPathElement e) => CborPathComponent(index: e.rawIndex, hardened: e.isHardened))
          .toList(),
    );

    return CborCryptoMultiAccounts(
      cryptoHDKeyList: <CborCryptoHDKey>[
        CborCryptoHDKey(
          isMaster: false,
          isPrivate: false,
          keyData: ed25519PrivateKey.publicKey.compressed,
          origin: cborCryptoKeypath,
          name: _walletModel.name,
        ),
      ],
    );
  }
}
