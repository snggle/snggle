import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/authenticate_repository.dart';
import 'package:snuggle/shared/model/mnemonic_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';
import 'package:snuggle/shared/utils/crypto/bip39.dart';

class AuthenticateService {
  final AuthenticateRepository _authenticateRepository = globalLocator<AuthenticateRepository>();

  Future<void> authenticateLater() async {
    await _authenticateRepository.setSetup(value: false);
    await _authenticateRepository.setAuthentication(value: false);
  }

  Future<bool> isAuthenticated() async {
    bool isAuthenticated = await _authenticateRepository.checkAuthentication() == 'true';
    return isAuthenticated;
  }

  Future<bool> checkSetupUp() async {
    bool isSetup = await _authenticateRepository.checkSetupPinPage() == 'true';
    return isSetup;
  }

  Future<void> storeAuthentication({required String pin}) async {
    MnemonicModel mnemonicModel = Bip39.generateMnemonic();
    Uint8List seed = await Bip39.mnemonicToSeed(mnemonic: mnemonicModel.value);
    Digest hashMnemonic = sha256.convert(seed);
    String encryptedHashMnemonic = Aes256.encrypt(pin, hashMnemonic.toString());

    await _authenticateRepository.setSetup(value: false);
    await _authenticateRepository.setAuthentication(value: true);
    await _authenticateRepository.setHashMnemonic(encryptedHashMnemonic.toString());
  }

  Future<bool> verifyAuthentication({required String pin}) async {
    String? hashMnemonic = await _authenticateRepository.getHashMnemonic();
    bool verify = Aes256.verifyPassword(pin, hashMnemonic.toString());
    return verify;
  }
}
