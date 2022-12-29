import 'package:snuggle/shared/utils/storage_manager.dart';

class CommonRepository {
  final String _isInitialSetupVisible = 'isInitialSetupVisible';
  final StorageManager _storageManager = StorageManager();

  Future<bool> isInitialSetupVisibleExist() async {
    bool isInitialSetupExist = await _storageManager.containsKeyData(key: _isInitialSetupVisible);
    return isInitialSetupExist;
  }

  Future<bool> getInitialSetupVisible() async {
    bool isSetup = await _storageManager.getKeyData(key: _isInitialSetupVisible) == 'true';
    return isSetup;
  }

  Future<void> setInitialSetupVisible({required bool value}) async {
    await _storageManager.writeKeyData(key: _isInitialSetupVisible, data: value.toString());
  }
}
