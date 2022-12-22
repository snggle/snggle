import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/setup_repository.dart';
import 'package:snuggle/shared/model/mnemonic_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';
import 'package:snuggle/shared/utils/crypto/bip39.dart';

class SetupService {
  final SetupRepository _setupRepository = globalLocator<SetupRepository>();

  Future<void> storeAuthentication({required String pin}) async {
    MnemonicModel mnemonicModel = Bip39.generateMnemonic();
    Uint8List seed = await Bip39.mnemonicToSeed(mnemonic: mnemonicModel.value);
    Digest hashMnemonic = sha256.convert(seed);
    String encryptedHashMnemonic = Aes256.encrypt(pin, hashMnemonic.toString());

    await _setupRepository.setSetupLater(value: false);
    await _setupRepository.setAuthentication(value: true);
    await _setupRepository.setHashMnemonic(encryptedHashMnemonic.toString());
  }

  Future<void> setupLater() async {
    await _setupRepository.setSetupLater(value: false);
  }
}
