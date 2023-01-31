import 'package:snuggle/infra/database_manager.dart';

class SettingsRepository {
  final DatabaseManager _databaseManager = DatabaseManager();

  Future<bool> isSetupPinExist() async {
    bool setupPinExistBool = await _databaseManager.containsKey(databaseEntryKey: DatabaseEntryKey.setupPinVisibleBool);
    return setupPinExistBool;
  }

  Future<bool> isSetupPinVisible() async {
    bool setupPinVisibleBool = await _databaseManager.read(databaseEntryKey: DatabaseEntryKey.setupPinVisibleBool) == 'true';
    return setupPinVisibleBool;
  }

  Future<void> setSetupPinVisible({required bool value}) async {
    await _databaseManager.write(databaseEntryKey: DatabaseEntryKey.setupPinVisibleBool, data: value.toString());
  }
}
