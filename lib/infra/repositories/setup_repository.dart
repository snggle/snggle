import 'package:snuggle/shared/utils/storage_manager.dart';

class SetupRepository {
  final String _hashMnemonicKey = 'hash_mnemonic';
  final String _isAuthenticatedKey = 'is_authenticated';
  final String _setup = 'setup';
  final StorageManager _storage = StorageManager();

  Future<void> setAuthentication({required bool value}) async {
    await _storage.writeKeyData(key: _isAuthenticatedKey, data: value.toString());
  }

  Future<void> setHashMnemonic(String hashMnemonic) async {
    await _storage.writeKeyData(key: _hashMnemonicKey, data: hashMnemonic);
  }

  Future<void> setSetupLater({required bool value}) async {
    await _storage.writeKeyData(key: _setup, data: value.toString());
  }
}
