import 'package:snggle/infra/managers/database_collection_wrapper.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/encrypted_database_manager.dart';

class SecretsRepository {
  final EncryptedDatabaseManager _encryptedDatabaseManager = EncryptedDatabaseManager();
  late final DatabaseCollectionWrapper<String> _databaseCollectionWrapper = DatabaseCollectionWrapper<String>(
    databaseManager: _encryptedDatabaseManager,
    databaseParentKey: DatabaseParentKey.secrets,
  );

  Future<Map<String, String>> getAllMapped() async {
    return _databaseCollectionWrapper.getAllMapped();
  }

  Future<String> getEncryptedSecrets(String containerPath) async {
    return _databaseCollectionWrapper.getById(containerPath);
  }

  Future<void> saveEncryptedSecrets(String containerPath, String encryptedSecrets) async {
    await _databaseCollectionWrapper.saveWithId(containerPath, encryptedSecrets);
  }

  Future<void> deleteSecrets(String containerPath) async {
    await _databaseCollectionWrapper.deleteById(containerPath);
  }
}
