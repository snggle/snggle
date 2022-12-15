import 'package:snuggle/shared/utils/storage_manager.dart';

class AuthRepository {
  final String _hashMnemonicKey = 'hash_mnemonic';
  final String _isAuthenticatedKey = 'is_authenticated';
  final String _setupPinPage = 'setup_pin_page';
  final StorageManager _storage = StorageManager();

  Future<String?> checkAuthentication() async {
    bool checkAuthenticationExists = await _storage.containsKeyData(key: _isAuthenticatedKey);
    if (checkAuthenticationExists == true) {
      return _storage.getKeyData(key: _isAuthenticatedKey);
    } else if (checkAuthenticationExists == false) {
      await setAuthentication(value: false);
    }
    return _storage.getKeyData(key: _isAuthenticatedKey);
  }

  Future<String?> checkSetupPinPage() async {
    bool checkSetupExists = await _storage.containsKeyData(key: _setupPinPage);
    if (checkSetupExists == true) {
      return _storage.getKeyData(key: _setupPinPage);
    } else {
      await Future.wait(<Future<void>>[setIntroductionSetup(value: true), setAuthentication(value: false)]);
      return _storage.getKeyData(key: _setupPinPage);
    }
  }

  Future<String?> getHashMnemonicPassword() async {
    return _storage.getKeyData(key: _hashMnemonicKey);
  }

  Future<void> setAuthentication({required bool value}) async {
    await _storage.writeKeyData(key: _isAuthenticatedKey, data: value.toString());
  }

  Future<void> setHashMnemonic(String hashMnemonic) async {
    await _storage.writeKeyData(key: _hashMnemonicKey, data: hashMnemonic);
  }

  Future<void> setIntroductionSetup({required bool value}) async {
    await _storage.writeKeyData(key: _setupPinPage, data: value.toString());
  }
}
