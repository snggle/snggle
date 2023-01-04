import 'package:snuggle/shared/utils/storage_manager.dart';

class HashMnemonicRepository {
  final String _hashMnemonicKey = 'hash_mnemonic';
  final StorageManager _storageManager = StorageManager();

  Future<void> setHashMnemonic(String hashMnemonic) async {
    await _storageManager.writeKeyData(key: _hashMnemonicKey, data: hashMnemonic);
  }
}
