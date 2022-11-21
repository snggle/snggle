import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/entity/vaults/vault_entity.dart';
import 'package:snuggle/infra/secure_collection_manager.dart';

class VaultsRepository {
  final SecureCollectionManager<VaultEntity> _vaultsSecureCollectionManager;

  VaultsRepository({
    SecureCollectionManager<VaultEntity>? vaultsSecureCollectionManager,
  }) : _vaultsSecureCollectionManager = vaultsSecureCollectionManager ?? globalLocator<SecureCollectionManager<VaultEntity>>();

  Future<void> deleteById(String id) async {
    await _vaultsSecureCollectionManager.deleteById(id);
  }

  Future<List<VaultEntity>> getAll() async {
    return _vaultsSecureCollectionManager.readAll();
  }

  Future<VaultEntity> getById(String id) async {
    VaultEntity? vaultEntity = await _vaultsSecureCollectionManager.getById(id);
    if (vaultEntity == null) {
      throw Exception('Vault with id $id not found');
    }
    return vaultEntity;
  }

  Future<void> save(VaultEntity vaultEntity) async {
    await _vaultsSecureCollectionManager.saveById(vaultEntity.uuid, vaultEntity);
  }
}
