import 'package:snggle/infra/entities/vault_entity.dart';
import 'package:snggle/infra/managers/secure_storage/encrypted_secure_storage_manager.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_collection_wrapper.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';

class VaultsRepository {
  final EncryptedSecureStorageManager _encryptedSecureStorageManager = EncryptedSecureStorageManager();
  late final SecureStorageCollectionWrapper<Map<String, dynamic>> _secureStorageCollectionWrapper = SecureStorageCollectionWrapper<Map<String, dynamic>>(
    secureStorageManager: _encryptedSecureStorageManager,
    secureStorageKey: SecureStorageKey.vaults,
  );

  Future<List<VaultEntity>> getAll() async {
    List<Map<String, dynamic>> allVaultsJson = await _secureStorageCollectionWrapper.getAll();
    List<VaultEntity> allVaults = allVaultsJson.map(VaultEntity.fromJson).toList();
    return allVaults;
  }

  Future<VaultEntity> getById(String id) async {
    Map<String, dynamic> vaultJson = await _secureStorageCollectionWrapper.getById(id);
    VaultEntity vaultEntity = VaultEntity.fromJson(vaultJson);
    return vaultEntity;
  }

  Future<void> save(VaultEntity vaultEntity) async {
    await _secureStorageCollectionWrapper.saveWithId(vaultEntity.uuid, vaultEntity.toJson());
  }

  Future<void> deleteById(String id) async {
    await _secureStorageCollectionWrapper.deleteById(id);
  }
}
