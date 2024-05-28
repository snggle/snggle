import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

// TODO(dominik): Temporary cubit implementation. Created for demo purposes.
//  After UI / list implementation responsibility of this cubit should be split into VaultListPageCubit and VaultListItemCubit
//  Additionally State of this cubit should be changed to VaultListPageState + tests should be written
class VaultListPageCubit extends Cubit<List<VaultModel>> {
  final SecretsService _secretsService;
  final VaultsService _vaultsService;

  VaultListPageCubit({
    SecretsService? secretsService,
    VaultsService? vaultsService,
  })  : _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _vaultsService = vaultsService ?? globalLocator<VaultsService>(),
        super(<VaultModel>[]);

  Future<void> deleteVault(VaultModel vaultModel) async {
    await _vaultsService.deleteVaultById(vaultModel.uuid);
    await _secretsService.delete(vaultModel.filesystemPath);
    await refresh();
  }

  Future<void> refresh() async {
    emit(await _vaultsService.getVaultList());
  }
}
