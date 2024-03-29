import 'dart:async';

import 'package:snggle/bloc/generic/list/a_list_cubit.dart';
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
    await _vaultsService.deleteVaultById(item.vaultModel.uuid);
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
    VaultModel vaultModel = await _vaultsService.getVaultById(item.vaultModel.uuid);
    VaultListItemModel vaultListItemModel = await _buildVaultListItemModel(vaultModel);
    return vaultListItemModel;
  }

  @override
  Future<void> saveToDatabase(VaultListItemModel item) {
    return _vaultsService.saveVault(item.vaultModel);
  }

  @override
  Future<List<VaultListItemModel>> filterBySearchPattern(List<VaultListItemModel> allItems, String searchPattern) async {
    List<VaultListItemModel> filteredItems = allItems.where((VaultListItemModel item) {
      return item.name.toLowerCase().contains(searchPattern.toLowerCase());
    }).toList();

    return filteredItems;
  }

  @override
  List<VaultListItemModel> sortItems(List<VaultListItemModel> items) {
    items.sort((VaultListItemModel a, VaultListItemModel b) {
      return a.vaultModel.index.compareTo(b.vaultModel.index);
    });

    List<VaultListItemModel> pinnedItems = items.where((VaultListItemModel item) => item.pinnedBool).toList();
    List<VaultListItemModel> unpinnedItems = items.where((VaultListItemModel item) => item.pinnedBool == false).toList();

    return <VaultListItemModel>[...pinnedItems, ...unpinnedItems];
  }

  // TODO(dominik): Temporary solution to create new vault. After implementing "create-vault-ui" this method should be removed.
  Future<void> createNewVault() async {
    final VaultModelFactory vaultModelFactory = globalLocator<VaultModelFactory>();

    VaultModel newVaultModel = await vaultModelFactory.createNewVault();

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
