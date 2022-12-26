import 'package:snuggle/shared/utils/storage_manager.dart';

class AuthenticateRepository {
  final String _hashMnemonicKey = 'hash_mnemonic';
  final String _isAuthenticatedKey = 'is_authenticated';
  final String _setup = 'setup';
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
    bool checkSetupExists = await _storage.containsKeyData(key: _setup);
    if (checkSetupExists == true) {
      return _storage.getKeyData(key: _setup);
    } else {
      await Future.wait(<Future<void>>[setSetup(value: true), setAuthentication(value: false)]);
      return _storage.getKeyData(key: _setup);
    }
  }

  Future<String?> getHashMnemonic() async {
    return _storage.getKeyData(key: _hashMnemonicKey);
  }

  Future<void> setAuthentication({required bool value}) async {
    await _storage.writeKeyData(key: _isAuthenticatedKey, data: value.toString());
  }

  Future<void> setHashMnemonic(String hashMnemonic) async {
    await _storage.writeKeyData(key: _hashMnemonicKey, data: hashMnemonic);
  }

  Future<void> setSetup({required bool value}) async {
    await _storage.writeKeyData(key: _setup, data: value.toString());
  }
}
