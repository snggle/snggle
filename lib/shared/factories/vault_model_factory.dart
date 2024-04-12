import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/services/vaults_service.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:uuid/uuid.dart';

class VaultModelFactory {
  final VaultsService _vaultsService;

  VaultModelFactory({VaultsService? vaultsService}) : _vaultsService = vaultsService ?? globalLocator<VaultsService>();

  Future<VaultModel> createNewVault([String? name]) async {
    int lastVaultIndex = await _vaultsService.getLastVaultIndex();
    VaultModel vaultModel = VaultModel(
      index: lastVaultIndex + 1,
      uuid: const Uuid().v4(),
      name: name,
    );

    return vaultModel;
  }

  VaultModel createFromEntity(VaultEntity vaultEntity) {
    return VaultModel(
      index: vaultEntity.index,
      uuid: vaultEntity.uuid,
      name: vaultEntity.name,
    );
  }
}
