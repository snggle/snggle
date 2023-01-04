import 'package:snuggle/shared/utils/storage_manager.dart';

class SettingsRepository {
  static const String isInitialSetupVisibleKey = 'is_initial_setup_visible';
  final StorageManager _storageManager = StorageManager();

  Future<bool> isInitialSetupVisibleExist() async {
    bool isInitialSetupExist = await _storageManager.containsKeyData(key: isInitialSetupVisibleKey);
    return isInitialSetupExist;
  }

  Future<bool> getInitialSetupVisible() async {
    bool isSetup = await _storageManager.getKeyData(key: isInitialSetupVisibleKey) == 'true';
    return isSetup;
  }

  Future<void> setInitialSetupVisible({required bool value}) async {
    await _storageManager.writeKeyData(key: isInitialSetupVisibleKey, data: value.toString());
  }
}
