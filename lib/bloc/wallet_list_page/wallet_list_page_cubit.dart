import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hd_wallet/hd_wallet.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/vault_secrets_service.dart';
import 'package:snggle/infra/services/wallet_secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/wallet_model_factory.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_creation_request_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/models/wallets/wallet_secrets_model.dart';

// TODO(dominik): Temporary cubit implementation. Created for demo purposes.
// After UI / list implementation responsibility of this cubit may be significantly rebuilt.
// For this reason, this cubit is not covered by tests, which should be added during UI implementation.
class WalletListPageCubit extends Cubit<List<WalletModel>> {
  final VaultModel vaultModel;
  final PasswordModel vaultPasswordModel;
  final WalletsService _walletsService;
  final WalletSecretsService _walletSecretsService;
  final VaultSecretsService _vaultSecretsService;

  WalletListPageCubit({
    required this.vaultModel,
    required this.vaultPasswordModel,
    WalletsService? walletsService,
    WalletSecretsService? walletSecretsService,
    VaultSecretsService? vaultSecretsService,
  })  : _walletsService = walletsService ?? globalLocator<WalletsService>(),
        _walletSecretsService = walletSecretsService ?? globalLocator<WalletSecretsService>(),
        _vaultSecretsService = vaultSecretsService ?? globalLocator<VaultSecretsService>(),
        super(<WalletModel>[]);

  Future<void> createNewWallet() async {
    WalletModelFactory walletModelFactory = globalLocator<WalletModelFactory>();
    VaultSecretsModel vaultSecretsModel = await _vaultSecretsService.getSecrets(vaultModel.uuid, vaultPasswordModel);

    // This section is used to determine the next derivation path segment for the new wallet
    // In current demo app, this value is calculated automatically, basing on the last wallet index existing in database
    // In the targeted app this value should be provided (or confirmed) by user an this functionality will be implemented on the next stages
    int lastWalletIndex = await _walletsService.getLastWalletIndex(vaultModel.uuid);
    int walletIndex = lastWalletIndex + 1;
    String derivationPath = "m/44'/118'/0'/0/${walletIndex}";

    // Seed calculation also will be changed (moved to the separate class). Currently, for the work organization reasons,
    // app allows to generate only one wallet type and this functionality is mocked here
    Uint8List seed = await vaultSecretsModel.mnemonicModel.calculateSeed();
    BIP32 rootNode = BIP32.fromSeed(seed);
    BIP32 derivedNode = rootNode.derivePath(derivationPath);

    WalletModel walletModel = await walletModelFactory.createNewWallet(
      WalletCreationRequestModel(
        index: walletIndex,
        vaultUuid: vaultModel.uuid,
        publicKey: derivedNode.publicKey,
        derivationPath: derivationPath,
      ),
    );

    WalletSecretsModel walletSecretsModel = WalletSecretsModel(
      walletUuid: walletModel.uuid,
      privateKey: derivedNode.privateKey!,
    );

    await _walletsService.saveWallet(walletModel);
    await _walletSecretsService.saveSecrets(walletSecretsModel, PasswordModel.defaultPassword());
    await refresh();
  }

  Future<void> deleteVault(WalletModel walletModel) async {
    await _walletsService.deleteWalletById(walletModel.uuid);
    await refresh();
  }

  Future<void> refresh() async {
    emit(await _walletsService.getWalletList(vaultModel.uuid));
  }
}
