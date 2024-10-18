import 'package:codec_utils/codec_utils.dart';
import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/vaults_wrapper/wallet_connect_page/wallet_connect_page_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_connect_option.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class WalletConnectPageCubit extends Cubit<WalletConnectPageState> {
  final SecretsService _secretsService = globalLocator<SecretsService>();

  final VaultModel _vaultModel;
  final PasswordModel _vaultPasswordModel;
  final WalletModel _walletModel;

  WalletConnectPageCubit({
    required VaultModel vaultModel,
    required PasswordModel vaultPasswordModel,
    required WalletModel walletModel,
  })  : _walletModel = walletModel,
        _vaultPasswordModel = vaultPasswordModel,
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

    VaultSecretsModel vaultSecretsModel = await _secretsService.get<VaultSecretsModel>(_vaultModel.filesystemPath, _vaultPasswordModel);
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
}
