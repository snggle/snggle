import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/factories/vault_model_factory.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

// TODO(dominik): Temporary cubit implementation. Created for demo purposes.
//  After UI / list implementation responsibility of this cubit should be split into VaultListPageCubit and VaultListItemCubit
//  Additionally State of this cubit should be changed to VaultListPageState + tests should be written
class VaultListPageCubit extends Cubit<List<VaultModel>> {
  final VaultsService _vaultsService;
  final VaultModelFactory _vaultModelFactory;

  VaultListPageCubit({
    VaultsService? vaultsService,
    VaultModelFactory? vaultModelFactory,
  })  : _vaultsService = vaultsService ?? globalLocator<VaultsService>(),
        _vaultModelFactory = vaultModelFactory ?? globalLocator<VaultModelFactory>(),
        super(<VaultModel>[]);

  Future<void> createNewVault() async {
    VaultModel newVaultModel = await _vaultModelFactory.createNewVault();
    await _vaultsService.saveVault(newVaultModel);
    await refresh();
  }

  Future<void> deleteVault(VaultModel vaultModel) async {
    await _vaultsService.deleteVaultById(vaultModel.uuid);
    await refresh();
  }

  Future<void> refresh() async {
    emit(await _vaultsService.getVaultList());
  }
}
