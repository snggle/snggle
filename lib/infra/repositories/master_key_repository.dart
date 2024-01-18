import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/infra/managers/decrypted_database_manager.dart';

class MasterKeyRepository {
  final DatabaseParentKey _databaseParentKey = DatabaseParentKey.encryptedMasterKey;
  final DecryptedDatabaseManager _decryptedDatabaseManager = DecryptedDatabaseManager();

  Future<bool> isMasterKeyExists() async {
    bool masterKeyExistsBool = await _decryptedDatabaseManager.containsKey(databaseParentKey: _databaseParentKey);
    return masterKeyExistsBool;
  }

  Future<Ciphertext> getMasterKey() async {
    String encryptedMasterKey = await _decryptedDatabaseManager.read(databaseParentKey: _databaseParentKey);
    return Ciphertext.fromJsonString(encryptedMasterKey);
  }

  Future<void> setMasterKey(Ciphertext ciphertext) async {
    await _decryptedDatabaseManager.write(
      databaseParentKey: _databaseParentKey,
      plaintextValue: ciphertext.toJsonString(prettyPrintBool: false),
    );
  }
}
