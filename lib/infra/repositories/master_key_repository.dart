import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/decrypted_database_manager.dart';

class MasterKeyRepository {
  final DatabaseParentKey _databaseParentKey = DatabaseParentKey.encryptedMasterKey;
  final DecryptedDatabaseManager _decryptedDatabaseManager = DecryptedDatabaseManager();

  Future<bool> isMasterKeyExists() async {
    bool masterKeyExistsBool = await _decryptedDatabaseManager.containsKey(databaseParentKey: _databaseParentKey);
    return masterKeyExistsBool;
  }

  Future<String> getMasterKey() async {
    String encryptedMasterKey = await _decryptedDatabaseManager.read(databaseParentKey: _databaseParentKey);
    return encryptedMasterKey;
  }

  Future<void> setMasterKey(String encryptedMasterKey) async {
    await _decryptedDatabaseManager.write(databaseParentKey: _databaseParentKey, plaintextValue: encryptedMasterKey);
  }
}
