import 'package:snuggle/shared/utils/storage_manager.dart';

class AuthRepository {
  String isAuthenticatedKey = 'is_authenticated';
  String encryptedHashMnemonicKey = 'encrypted_hash_mnemonic';
  String setupPinPage = 'setup_pin_page';

  Future<void> setAuthenticationTrue() async {
    await StorageManager().writeKeyData(key: isAuthenticatedKey, data: 'true');
  }

  Future<void> setAuthenticationFalse() async {
    await StorageManager().writeKeyData(key: isAuthenticatedKey, data: 'false');
  }

  Future<void> setHashMnemonicPassword(String encryptedMnemonicHash) async {
    await StorageManager().writeKeyData(key: encryptedHashMnemonicKey, data: encryptedMnemonicHash);
  }

  Future<String?> getHashMnemonicPassword() async {
    return StorageManager().getKeyData(key: encryptedHashMnemonicKey);
  }

  Future<String?> checkAuthentication() async {
    return StorageManager().getKeyData(key: isAuthenticatedKey);
  }

  Future<void> setSetupPinPageFalse() async {
    await StorageManager().writeKeyData(key: setupPinPage, data: 'false');
  }

  Future<bool> checkSetupPinPage() async {
    return StorageManager().containsKeyData(key: setupPinPage);
  }
}
