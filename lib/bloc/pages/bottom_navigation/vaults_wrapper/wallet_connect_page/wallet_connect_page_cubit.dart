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
    required VaultModel vaultModel,
    required WalletModel walletModel,
  })  : _walletModel = walletModel,
        _vaultModel = vaultModel,
        super(const WalletConnectPageState());

  void changeConnectOption(WalletConnectOption walletConnectOption) {
    emit(WalletConnectPageState(walletConnectOption: walletConnectOption));
  }

  Future<CborCryptoHDKey> getCborCryptoHDKey({required bool connectAllBool}) async {
    Secp256k1Derivator secp256k1Derivator = Secp256k1Derivator();
    LegacyDerivationPath legacyDerivationPath = LegacyDerivationPath.parse(_walletModel.derivationPath);

    List<LegacyDerivationPathElement> parentPathElements = legacyDerivationPath.pathElements.sublist(
      0,
      legacyDerivationPath.pathElements.length - (connectAllBool ? 2 : 1),
    );
    LegacyDerivationPathElement lastPathElement = legacyDerivationPath.pathElements.last;

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
      depth: (connectAllBool ? 3 : 4),
      sourceFingerprint: secp256k1PrivateKey.metadata.fingerprint.toInt(),
    );

    return CborCryptoHDKey(
      isMaster: false,
      isPrivate: false,
      keyData: secp256k1PrivateKey.publicKey.compressed,
      chainCode: secp256k1PrivateKey.metadata.chainCode,
      origin: cborCryptoKeypath,
      children: connectAllBool
          ? null
          : CborCryptoKeypath(
              components: <CborPathComponent>[
                CborPathComponent(index: lastPathElement.rawIndex, hardened: lastPathElement.isHardened),
              ],
            ),
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
      components: derivationPath.pathElements
          .map(
            (LegacyDerivationPathElement e) => CborPathComponent(index: e.rawIndex, hardened: e.isHardened),
          )
          .toList(),
      sourceFingerprint: 0x12345678,
    );

    CborCryptoHDKey solanaKey = CborCryptoHDKey(
      isMaster: false,
      isPrivate: false,
      keyData: ed25519PrivateKey.publicKey.compressed,
      origin: cborCryptoKeypath,
      name: _walletModel.name,
    );

    return CborCryptoMultiAccounts(
      masterFingerprint: 'e9181cf3',
      cryptoHDKeyList: <CborCryptoHDKey>[solanaKey],
      device: 'keystone',
      deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
      deviceVersion: '1.0.2',
    );
  }
}
