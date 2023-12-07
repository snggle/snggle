import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/managers/database_collection_wrapper.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/encrypted_database_manager.dart';

class VaultsRepository {
  final EncryptedDatabaseManager _encryptedDatabaseManager = EncryptedDatabaseManager();
  late final DatabaseCollectionWrapper<Map<String, dynamic>> _databaseCollectionWrapper = DatabaseCollectionWrapper<Map<String, dynamic>>(
    databaseManager: _encryptedDatabaseManager,
    databaseParentKey: DatabaseParentKey.vaults,
  );

  Future<List<VaultEntity>> getAll() async {
    List<Map<String, dynamic>> allVaultsJson = await _databaseCollectionWrapper.getAll();
    List<VaultEntity> allVaults = allVaultsJson.map(VaultEntity.fromJson).toList();
    return allVaults;
  }

  Future<VaultEntity> getById(String id) async {
    Map<String, dynamic> vaultJson = await _databaseCollectionWrapper.getById(id);
    VaultEntity vaultEntity = VaultEntity.fromJson(vaultJson);
    return vaultEntity;
  }

  Future<void> save(VaultEntity vaultEntity) async {
    await _databaseCollectionWrapper.saveWithId(vaultEntity.uuid, vaultEntity.toJson());
  }

  Future<void> deleteById(String id) async {
    await _databaseCollectionWrapper.deleteById(id);
  }
}
