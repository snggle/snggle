import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/repositories/private_key_repository.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/utils/crypto/aes256.dart';

class AuthenticationService {
  final PrivateKeyRepository _privateKeyRepository = globalLocator<PrivateKeyRepository>();

  Future<void> setupPrivateKey({required MnemonicModel mnemonicModel, required String pin}) async {
    Uint8List mnemonicSeed = await mnemonicModel.calculateSeed();
    Digest privateKey = sha256.convert(mnemonicSeed);
    String encryptedPrivateKey = Aes256.encrypt(pin, privateKey.toString());
    await _privateKeyRepository.setPrivateKey(encryptedPrivateKey.toString());
  }
}
