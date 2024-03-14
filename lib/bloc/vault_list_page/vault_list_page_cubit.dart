import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/vault_list_page/vault_list_page_state.dart';
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
import 'package:snggle/shared/models/vaults/vault_selection_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';

class VaultListPageCubit extends Cubit<VaultListPageState> {
  final SecretsService _secretsService;
  final VaultsService _vaultsService;
  final WalletsService _walletsService;
  final VaultModelFactory _vaultModelFactory;

  VaultListPageCubit({
    SecretsService? secretsService,
    VaultsService? vaultsService,
    WalletsService? walletsService,
    VaultModelFactory? vaultModelFactory,
  })  : _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _vaultsService = vaultsService ?? globalLocator<VaultsService>(),
        _walletsService = walletsService ?? globalLocator<WalletsService>(),
        _vaultModelFactory = vaultModelFactory ?? globalLocator<VaultModelFactory>(),
        super(VaultListPageState(loadingBool: true));

  // TODO(dominik): Temporary solution to get the vault name. After implementing "create-vault-ui" this method should be removed.
  Future<void> createNewVault() async {
    VaultModel newVaultModel = await _vaultModelFactory.createNewVault();

    MnemonicModel mnemonicModel = MnemonicModel.generate();
    VaultSecretsModel vaultSecretsModel = VaultSecretsModel(containerPathModel: newVaultModel.containerPathModel, mnemonicModel: mnemonicModel);

    await _vaultsService.saveVault(newVaultModel);
    await _secretsService.saveSecrets(vaultSecretsModel, PasswordModel.defaultPassword());
    await refreshAll();
  }

  Future<void> deleteVault(VaultListItemModel vaultListItemModel) async {
    List<WalletModel> vaultWallets = await _walletsService.getWalletList(vaultListItemModel.vaultModel.uuid);
    for (WalletModel walletModel in vaultWallets) {
      await _walletsService.deleteWalletById(walletModel.uuid);
      await _secretsService.deleteSecrets(walletModel.containerPathModel);
    }

    await _vaultsService.deleteVaultById(vaultListItemModel.vaultModel.uuid);
    await _secretsService.deleteSecrets(vaultListItemModel.vaultModel.containerPathModel);

    await refreshAll();
  }

  Future<void> refreshAll() async {
    List<VaultModel> vaultModelList = await _vaultsService.getVaultList();
    List<VaultListItemModel> vaultListItemModelList = <VaultListItemModel>[];
    for (VaultModel vaultModel in vaultModelList) {
      VaultListItemModel vaultListItemModel = await _buildVaultListItemModel(vaultModel);
      vaultListItemModelList.add(vaultListItemModel);
    }

    emit(VaultListPageState(loadingBool: false, allVaults: vaultListItemModelList));
  }

  Future<void> refreshSingle(VaultListItemModel vaultListItemModel) async {
    List<VaultModel> vaultModelList = await _vaultsService.getVaultList();

    VaultModel vaultModel = vaultModelList.firstWhere((VaultModel element) => element.uuid == vaultListItemModel.vaultModel.uuid);
    VaultListItemModel refreshedVaultListItemModel = await _buildVaultListItemModel(vaultModel);

    List<VaultListItemModel> refreshedVaults = List<VaultListItemModel>.from(state.allVaults)
      ..remove(vaultListItemModel)
      ..add(refreshedVaultListItemModel);

    emit(state.copyWith(allVaults: refreshedVaults));
  }

  void searchVaults(String? searchPattern) {
    emit(VaultListPageState(
      loadingBool: false,
      searchBoxVisibleBool: searchPattern != null,
      vaultSelectionModel: state.vaultSelectionModel,
      searchPattern: searchPattern,
      allVaults: state.allVaults,
    ));
  }

  void selectVault(VaultListItemModel vaultListItemModel) {
    List<VaultListItemModel> selectedVaults = List<VaultListItemModel>.from(state.selectedVaults, growable: true)..add(vaultListItemModel);
    emit(state.copyWith(vaultSelectionModel: VaultSelectionModel(selectedVaults)));
  }

  void selectAll() {
    if (state.selectedVaults.length == state.allVaults.length) {
      emit(state.copyWith(vaultSelectionModel: VaultSelectionModel.empty()));
    } else {
      emit(state.copyWith(vaultSelectionModel: VaultSelectionModel(state.allVaults)));
    }
  }

  void unselectVault(VaultListItemModel vaultListItemModel) {
    List<VaultListItemModel> selectedVaults = List<VaultListItemModel>.from(state.selectedVaults, growable: true)..remove(vaultListItemModel);
    emit(state.copyWith(vaultSelectionModel: VaultSelectionModel(selectedVaults)));
  }

  void disableSelection() {
    emit(VaultListPageState(allVaults: state.allVaults, loadingBool: false));
  }

  Future<void> updatePinnedVaults({required List<VaultListItemModel> selectedVaults, required bool pinnedBool}) async {
    List<VaultListItemModel> newVaults = state.allVaults;
    for (int i = 0; i < newVaults.length; i++) {
      VaultListItemModel vaultListItemModel = newVaults[i];
      if (selectedVaults.contains(vaultListItemModel)) {
        VaultModel vaultModel = vaultListItemModel.vaultModel.copyWith(pinnedBool: pinnedBool);

        newVaults[i] = vaultListItemModel.copyWith(vaultModel: vaultModel);
        unawaited(_vaultsService.saveVault(vaultModel));
      }
    }
    emit(VaultListPageState(allVaults: newVaults, loadingBool: false));
  }

  Future<void> updateEncryptedVaults({required List<VaultListItemModel> selectedVaults, required bool encryptedBool}) async {
    List<VaultListItemModel> newVaults = List<VaultListItemModel>.from(state.allVaults);
    for (int i = 0; i < newVaults.length; i++) {
      VaultListItemModel vaultListItemModel = newVaults[i];
      if (selectedVaults.contains(vaultListItemModel)) {
        // TODO(dominik): Temporary solution to get user password. After implementing "secrets-pin-pages-ui" this condition should be replaced by custom page requesting user's password
        if (encryptedBool) {
          VaultSecretsModel secretsModel = await _secretsService.getSecrets(vaultListItemModel.vaultModel.containerPathModel, PasswordModel.defaultPassword());
          unawaited(_secretsService.saveSecrets(secretsModel, PasswordModel.fromPlaintext('1111')));
        } else {
          VaultSecretsModel secretsModel = await _secretsService.getSecrets(
            vaultListItemModel.vaultModel.containerPathModel,
            PasswordModel.fromPlaintext('1111'),
          );
          unawaited(_secretsService.saveSecrets(secretsModel, PasswordModel.defaultPassword()));
        }

        newVaults[i] = vaultListItemModel.copyWith(encryptedBool: encryptedBool);
      }
    }
    emit(VaultListPageState(allVaults: newVaults, loadingBool: false));
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
