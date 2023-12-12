import 'package:snggle/infra/managers/database_collection_wrapper.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/encrypted_database_manager.dart';

class SecretsRepository {
  final EncryptedDatabaseManager _encryptedDatabaseManager = EncryptedDatabaseManager();
  late final DatabaseCollectionWrapper<String> _databaseCollectionWrapper = DatabaseCollectionWrapper<String>(
    databaseManager: _encryptedDatabaseManager,
    databaseParentKey: DatabaseParentKey.secrets,
  );

  Future<String> getEncryptedSecrets(String containerId) async {
    return _databaseCollectionWrapper.getById(containerId);
  }

  Future<void> saveEncryptedSecrets(String containerId, String encryptedSecrets) async {
    await _databaseCollectionWrapper.saveWithId(containerId, encryptedSecrets);
  }

  Future<void> deleteSecrets(String containerId) async {
    await _databaseCollectionWrapper.deleteById(containerId);
  }
}
