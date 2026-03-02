import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_manager.dart';

class IsarDatabaseVersionRepository {
  final SecureStorageKey _secureStorageKey = SecureStorageKey.isarDatabaseVersion;
  final SecureStorageManager _secureStorageManager = SecureStorageManager();

  Future<bool> isIsarDatabaseVersionExists() async {
    bool isarDatabaseVersionExistsBool = await _secureStorageManager.containsKey(secureStorageKey: _secureStorageKey);
    return isarDatabaseVersionExistsBool;
  }

  Future<String> getIsarDatabaseVersion() async {
    try {
      String encryptedIsarDatabaseVersion = await _secureStorageManager.read(secureStorageKey: _secureStorageKey);
      return encryptedIsarDatabaseVersion;
    } catch (_) {
      return '0';
    }
  }

  Future<void> setIsarDatabaseVersion(String encryptedIsarDatabaseVersion) async {
    await _secureStorageManager.write(secureStorageKey: _secureStorageKey, plaintextValue: encryptedIsarDatabaseVersion);
  }
}
