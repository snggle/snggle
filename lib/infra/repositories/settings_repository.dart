import 'package:snggle/infra/managers/database_entry_key.dart';
import 'package:snggle/infra/managers/decrypted_database_manager.dart';

class SettingsRepository {
  final DecryptedDatabaseManager _decryptedDatabaseManager  = DecryptedDatabaseManager();

  Future<bool> isSetupPinExist() async {
    bool setupPinExistBool = await _decryptedDatabaseManager.containsKey(databaseEntryKey: DatabaseEntryKey.setupPinVisibleBool);
    return setupPinExistBool;
  }

  Future<bool> isSetupPinVisible() async {
    bool setupPinVisibleBool = await _decryptedDatabaseManager.read(databaseEntryKey: DatabaseEntryKey.setupPinVisibleBool) == 'true';
    return setupPinVisibleBool;
  }

  Future<void> setSetupPinVisible({required bool value}) async {
    await _decryptedDatabaseManager.write(databaseEntryKey: DatabaseEntryKey.setupPinVisibleBool, data: value.toString());
  }
}
