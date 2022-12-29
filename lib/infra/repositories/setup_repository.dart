import 'package:snuggle/shared/utils/storage_manager.dart';

class SetupRepository {
  final String _hashMnemonicKey = 'hash_mnemonic';
  final String _isAuthenticatedKey = 'is_authenticated';
  final StorageManager _storageManager = StorageManager();

  Future<void> setAuthentication({required bool value}) async {
    await _storageManager.writeKeyData(key: _isAuthenticatedKey, data: value.toString());
  }

  Future<void> setHashMnemonic(String hashMnemonic) async {
    await _storageManager.writeKeyData(key: _hashMnemonicKey, data: hashMnemonic);
  }
}
