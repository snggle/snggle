import 'package:snuggle/shared/utils/storage_manager.dart';

class AuthRepository {
  String encryptedHashMnemonicKey = 'encrypted_hash_mnemonic';
  String isAuthenticatedKey = 'is_authenticated';
  String setupPinPage = 'setup_pin_page';

  Future<String?> checkAuthentication() async {
    bool checkAuthenticationExists = await StorageManager().containsKeyData(key: isAuthenticatedKey);
    if (checkAuthenticationExists == true) {
      return StorageManager().getKeyData(key: isAuthenticatedKey);
    } else if (checkAuthenticationExists == false) {
      await setAuthenticationFalse();
    }
    return StorageManager().getKeyData(key: isAuthenticatedKey);
  }

  Future<String?> checkSetupPinPage() async {
    bool checkSetupExists = await StorageManager().containsKeyData(key: setupPinPage);
    if (checkSetupExists == true) {
      return StorageManager().getKeyData(key: setupPinPage);
    } else if (checkSetupExists == false) {
      await Future.wait(<Future<void>>[setSetupPinPageTrue(), setAuthenticationFalse()]);
    }
    return StorageManager().getKeyData(key: setupPinPage);
  }

  Future<String?> getHashMnemonicPassword() async {
    return StorageManager().getKeyData(key: encryptedHashMnemonicKey);
  }

  Future<void> setAuthenticationTrue() async {
    await StorageManager().writeKeyData(key: isAuthenticatedKey, data: 'true');
  }

  Future<void> setAuthenticationFalse() async {
    await StorageManager().writeKeyData(key: isAuthenticatedKey, data: 'false');
  }

  Future<void> setHashMnemonicPassword(String encryptedMnemonicHash) async {
    await StorageManager().writeKeyData(key: encryptedHashMnemonicKey, data: encryptedMnemonicHash);
  }

  Future<void> setSetupPinPageFalse() async {
    await StorageManager().writeKeyData(key: setupPinPage, data: 'false');
  }

  Future<void> setSetupPinPageTrue() async {
    await StorageManager().writeKeyData(key: setupPinPage, data: 'true');
  }
}
