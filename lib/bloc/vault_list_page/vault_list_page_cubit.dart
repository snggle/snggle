import 'dart:async';

import 'package:snggle/bloc/list/a_list_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/models/vaults/vault_secrets_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class VaultListPageCubit extends AListCubit<VaultListItemModel> {
  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be removed.
  final VaultModelFactory _vaultModelFactory = globalLocator<VaultModelFactory>();

  final SecretsService _secretsService;
  final VaultsService _vaultsService;
  final WalletsService _walletsService;

  VaultListPageCubit({
    SecretsService? secretsService,
    VaultsService? vaultsService,
    WalletsService? walletsService,
  })  : _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _vaultsService = vaultsService ?? globalLocator<VaultsService>(),
        _walletsService = walletsService ?? globalLocator<WalletsService>();

  @override
  Future<void> deleteFromDatabase(VaultListItemModel item) async {
    List<WalletModel> vaultWallets = await _walletsService.getWalletList(item.vaultModel.uuid);
    for (WalletModel walletModel in vaultWallets) {
      await _walletsService.deleteWalletById(walletModel.uuid);
      await _secretsService.deleteSecrets(walletModel.containerPathModel);
    }

    await _vaultsService.deleteVaultById(item.vaultModel.uuid);
    await _secretsService.deleteSecrets(item.vaultModel.containerPathModel);
  }

  @override
  Future<List<VaultListItemModel>> fetchAllFromDatabase() async {
    List<VaultModel> vaultModelList = await _vaultsService.getVaultList();

    List<VaultListItemModel> vaultListItemModelList = <VaultListItemModel>[];
    for (VaultModel vaultModel in vaultModelList) {
      VaultListItemModel vaultListItemModel = await _buildVaultListItemModel(vaultModel);
      vaultListItemModelList.add(vaultListItemModel);
    }

    return vaultListItemModelList;
  }

  @override
  Future<VaultListItemModel> fetchSingleFromDatabase(VaultListItemModel item) async {
    List<VaultModel> vaultModelList = await _vaultsService.getVaultList();

    VaultModel vaultModel = vaultModelList.firstWhere((VaultModel element) => element.uuid == item.vaultModel.uuid);
    VaultListItemModel vaultListItemModel = await _buildVaultListItemModel(vaultModel);

    return vaultListItemModel;
  }

  @override
  Future<void> saveToDatabase(VaultListItemModel item) {
    return _vaultsService.saveVault(item.vaultModel);
  }

  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be removed.
  Future<void> createNewVault() async {
    VaultModel newVaultModel = await _vaultModelFactory.createNewVault();

    MnemonicModel mnemonicModel = MnemonicModel.generate();
    VaultSecretsModel vaultSecretsModel = VaultSecretsModel(containerPathModel: newVaultModel.containerPathModel, mnemonicModel: mnemonicModel);

    await _vaultsService.saveVault(newVaultModel);
    await _secretsService.saveSecrets(vaultSecretsModel, PasswordModel.defaultPassword());
    await refreshAll();
  }


  Future<VaultListItemModel> _buildVaultListItemModel(VaultModel vaultModel) async {
    bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(vaultModel.containerPathModel, PasswordModel.defaultPassword());
    List<WalletModel> vaultWallets = await _walletsService.getWalletList(vaultModel.uuid);

    VaultListItemModel vaultListItemModel = VaultListItemModel(
      encryptedBool: defaultPasswordBool == false,
      vaultWallets: vaultWallets,
      vaultModel: vaultModel,
    );

    return vaultListItemModel;
  }
}
