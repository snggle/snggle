import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:snuggle/infra/repositories/auth_repository.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';
import 'package:snuggle/shared/utils/crypto/bip39.dart';

class AuthService {
  Future<void> authenticateLater() async {
    await AuthRepository().setSetupPinPageFalse();
    await AuthRepository().setAuthenticationFalse();
  }

  Future<bool> isAuthenticated() async {
    bool isAuthenticated = await AuthRepository().checkAuthentication() == 'true';
    return isAuthenticated;
  }

  Future<bool> isAuthenticationSetup() async {
    bool isAuthenticationSetup = await AuthRepository().checkSetupPinPage();
    return isAuthenticationSetup;
  }

  Future<void> storeAuthentication({required String pin}) async {
    MnemonicModel mnemonicModel = Bip39.generateMnemonic();
    Uint8List seed = await Bip39.mnemonicToSeed(mnemonic: mnemonicModel.value);
    Digest hashMnemonic = sha256.convert(seed);
    String encryptedHashMnemonic = Aes256.encrypt(pin, hashMnemonic.toString());

    await AuthRepository().setAuthenticationTrue();
    await AuthRepository().setHashMnemonicPassword(encryptedHashMnemonic.toString());
  }

  Future<bool> verifyAuthentication({required String pin}) async {
    String? encryptedHashMnemonic = await AuthRepository().getHashMnemonicPassword();
    bool verify = Aes256.verifyPassword(pin, encryptedHashMnemonic.toString());
    return verify;
  }
}
