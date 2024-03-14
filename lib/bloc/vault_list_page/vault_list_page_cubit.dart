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

// TODO(dominik): Temporary cubit implementation. Created for demo purposes.
//  After UI / list implementation responsibility of this cubit should be split into VaultListPageCubit and VaultListItemCubit
//  Additionally State of this cubit should be changed to VaultListPageState + tests should be written
class VaultListPageCubit extends Cubit<VaultListPageState> {
  final SecretsService _secretsService;
  final VaultsService _vaultsService;
  final WalletsService _walletsService = globalLocator<WalletsService>();

  final VaultModelFactory _vaultModelFactory;

  VaultListPageCubit({
    SecretsService? secretsService,
    VaultsService? vaultsService,
    VaultModelFactory? vaultModelFactory,
  })  : _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _vaultsService = vaultsService ?? globalLocator<VaultsService>(),
        _vaultModelFactory = vaultModelFactory ?? globalLocator<VaultModelFactory>(),
        super(VaultListPageState(loadingBool: true));

  Future<void> createNewVault() async {
    VaultModel newVaultModel = await _vaultModelFactory.createNewVault();

    MnemonicModel mnemonicModel = MnemonicModel.generate();
    VaultSecretsModel vaultSecretsModel = VaultSecretsModel(containerPathModel: newVaultModel.containerPathModel, mnemonicModel: mnemonicModel);

    await _vaultsService.saveVault(newVaultModel);
    await _secretsService.saveSecrets(vaultSecretsModel, PasswordModel.defaultPassword());
    await refresh();
  }

  void disableSelection() {
    emit(VaultListPageState(allVaults: state.allVaults, loadingBool: false));
  }

  Future<void> deleteVault(VaultModel vaultModel) async {
    await _vaultsService.deleteVaultById(vaultModel.uuid);
    await _secretsService.deleteSecrets(vaultModel.containerPathModel);
    await refresh();
  }

  void selectAll() {
    if (state.selectedVaults.length == state.allVaults.length) {
      emit(state.copyWith(vaultSelectionModel: VaultSelectionModel.empty()));
    } else {
      emit(state.copyWith(vaultSelectionModel: VaultSelectionModel(state.allVaults)));
    }
  }
  
  void searchVaults(String pattern) {
    emit(state.copyWith(searchPattern: pattern));
  }

  Future<void> changeSelectionPinStatus({required List<VaultListItemModel> selectedVaults, required bool pinnedBool}) async {
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

  Future<void> changeSelectionEncryptionStatus({required List<VaultListItemModel> selectedVaults, required bool encryptedBool}) async {
    List<VaultListItemModel> newVaults = List<VaultListItemModel>.from(state.allVaults);
    for (int i = 0; i < newVaults.length; i++) {
      VaultListItemModel vaultListItemModel = newVaults[i];
      if (selectedVaults.contains(vaultListItemModel)) {
        newVaults[i] = vaultListItemModel.copyWith(encryptedBool: encryptedBool);
      }
    }
    emit(VaultListPageState(allVaults: newVaults, loadingBool: false));
  }

  void selectVault(VaultListItemModel vaultListItemModel) {
    List<VaultListItemModel> selectedVaults = List<VaultListItemModel>.from(state.selectedVaults, growable: true)..add(vaultListItemModel);
    emit(state.copyWith(vaultSelectionModel: VaultSelectionModel(selectedVaults)));
  }

  void unselectVault(VaultListItemModel vaultListItemModel) {
    List<VaultListItemModel> selectedVaults = List<VaultListItemModel>.from(state.selectedVaults, growable: true)..remove(vaultListItemModel);
    emit(state.copyWith(vaultSelectionModel: VaultSelectionModel(selectedVaults)));
  }

  Future<void> refresh() async {
    List<VaultModel> vaultModelList = await _vaultsService.getVaultList();
    List<VaultListItemModel> vaultListItemModelList = <VaultListItemModel>[];
    for (VaultModel vaultModel in vaultModelList) {
      bool defaultPasswordBool = await _secretsService.isSecretsPasswordValid(vaultModel.containerPathModel, PasswordModel.defaultPassword());
      List<WalletModel> vaultWallets = await _walletsService.getWalletList(vaultModel.uuid);

      vaultListItemModelList.add(VaultListItemModel(
        encryptedBool: defaultPasswordBool == false,
        vaultModel: vaultModel,
        vaultWallets: vaultWallets,
      ));
    }

    emit(VaultListPageState(loadingBool: false, allVaults: vaultListItemModelList));
  }
}
