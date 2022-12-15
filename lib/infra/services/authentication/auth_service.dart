import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/auth_repository.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';
import 'package:snuggle/shared/utils/crypto/bip39.dart';

class AuthService {
  final AuthRepository _authRepository = globalLocator<AuthRepository>();

  Future<void> authenticateLater() async {
    await _authRepository.setIntroductionSetup(value: false);
    await _authRepository.setAuthentication(value: false);
  }

  Future<bool> isAuthenticated() async {
    bool isAuthenticated = await _authRepository.checkAuthentication() == 'true';
    return isAuthenticated;
  }

  Future<bool> checkSetupUp() async {
    bool isSetup = await _authRepository.checkSetupPinPage() == 'true';
    return isSetup;
  }

  Future<void> storeAuthentication({required String pin}) async {
    MnemonicModel mnemonicModel = Bip39.generateMnemonic();
    Uint8List seed = await Bip39.mnemonicToSeed(mnemonic: mnemonicModel.value);
    Digest hashMnemonic = sha256.convert(seed);
    String encryptedHashMnemonic = Aes256.encrypt(pin, hashMnemonic.toString());

    await _authRepository.setIntroductionSetup(value: false);
    await _authRepository.setAuthentication(value: true);
    await _authRepository.setHashMnemonic(encryptedHashMnemonic.toString());
  }

  Future<bool> verifyAuthentication({required String pin}) async {
    String? hashMnemonic = await _authRepository.getHashMnemonicPassword();
    bool verify = Aes256.verifyPassword(pin, hashMnemonic.toString());
    return verify;
  }
}
