import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';
import 'package:snuggle/shared/utils/crypto/bip39.dart';
import 'package:snuggle/shared/utils/storage_manager.dart';

class AuthService {
  static Future<bool> authenticateLater() async {
    try {
      await StorageManager().writeKeyData(
        key: 'encryptedMnemonicHash',
        data: '0000',
      );
      await StorageManager().writeKeyData(
        key: 'isAuthenticated',
        data: 'false',
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isAuthenticated() async {
    bool isAuthenticated = await StorageManager().getKeyData(key: 'isAuthenticated') == 'true';
    return isAuthenticated;
  }

  static Future<bool> isAuthenticationSetup() async {
    bool isAuthenticationSetup = await StorageManager().containsKeyData(
      key: 'encryptedMnemonicHash',
    );
    if (isAuthenticationSetup) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> storeAuthentication({required String pin}) async {
    MnemonicModel mnemonicModel = Bip39.generateMnemonic();
    Uint8List seed = await Bip39.mnemonicToSeed(mnemonic: mnemonicModel.value);
    Digest mnemonicHash = sha256.convert(seed);
    String encryptedMnemonicHash = Aes256.encrypt(pin, mnemonicHash.toString());
    try {
      await StorageManager().writeKeyData(
        key: 'isAuthenticated',
        data: 'true',
      );
      await StorageManager().writeKeyData(
        key: 'encryptedMnemonicHash',
        data: encryptedMnemonicHash,
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> verifyAuthentication({required String pin}) async {
    String? encryptedMnemonicHash = await StorageManager().getKeyData(key: 'encryptedMnemonicHash');
    bool verify = Aes256.verifyPassword(pin, encryptedMnemonicHash.toString());
    return verify;
  }
}
