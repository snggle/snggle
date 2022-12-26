import 'package:snuggle/shared/utils/storage_manager.dart';

class InitialRepository {
  final String _isAuthenticatedKey = 'is_authenticated';
  final String _setup = 'setup';
  final StorageManager _storage = StorageManager();

  Future<bool> checkSetup() async {
    bool isSetupExist = await _storage.containsKeyData(key: _setup);
    if (isSetupExist == true) {
      bool isSetup = await _storage.getKeyData(key: _setup) == 'true';
      return isSetup;
    } else {
      await _storage.writeKeyData(key: _setup, data: 'true');
      return true;
    }
  }

  Future<String?> checkAuthentication() async {
    bool checkAuthenticationExists = await _storage.containsKeyData(key: _isAuthenticatedKey);
    if (checkAuthenticationExists == true) {
      return _storage.getKeyData(key: _isAuthenticatedKey);
    } else if (checkAuthenticationExists == false) {
      await _storage.writeKeyData(key: _isAuthenticatedKey, data: 'false');
    }
    return _storage.getKeyData(key: _isAuthenticatedKey);
  }
}
