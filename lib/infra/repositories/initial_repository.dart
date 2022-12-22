import 'package:snuggle/shared/utils/storage_manager.dart';

class InitialRepository {
  final String _setup = 'setup';
  final StorageManager _storageManager = StorageManager();

  Future<bool> checkSetup() async {
    bool isSetupExist = await _storageManager.containsKeyData(key: _setup);
    if (isSetupExist == true) {
      bool isSetup = await _storageManager.getKeyData(key: _setup) == 'true';
      return isSetup;
    } else {
      await _storageManager.writeKeyData(key: _setup, data: 'true');
      return true;
    }
  }
}
