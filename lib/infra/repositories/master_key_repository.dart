import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_manager.dart';

class MasterKeyRepository {
  final SecureStorageKey _secureStorageKey = SecureStorageKey.encryptedMasterKey;
  final SecureStorageManager _secureStorageManager = SecureStorageManager();

  Future<bool> isMasterKeyExists() async {
    bool masterKeyExistsBool = await _secureStorageManager.containsKey(secureStorageKey: _secureStorageKey);
    return masterKeyExistsBool;
  }

  Future<String> getMasterKey() async {
    String encryptedMasterKey = await _secureStorageManager.read(secureStorageKey: _secureStorageKey);
    return encryptedMasterKey;
  }

  Future<void> setMasterKey(String encryptedMasterKey) async {
    await _secureStorageManager.write(secureStorageKey: _secureStorageKey, plaintextValue: encryptedMasterKey);
  }
}
