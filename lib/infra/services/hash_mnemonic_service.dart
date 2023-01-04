import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/hash_mnemonic_repository.dart';
import 'package:snuggle/infra/repositories/settings_repository.dart';
import 'package:snuggle/shared/model/mnemonic_model.dart';
import 'package:snuggle/shared/utils/crypto/aes256.dart';
import 'package:snuggle/shared/utils/crypto/bip39.dart';

//RENAME
class HashMnemonicService {
  final HashMnemonicRepository _hashMnemonicRepository = globalLocator<HashMnemonicRepository>();
  final SettingsRepository _settingsRepository = globalLocator<SettingsRepository>();

  Future<void> storeAuthentication({required String pin}) async {
    MnemonicModel mnemonicModel = Bip39.generateMnemonic();
    Uint8List seed = await Bip39.mnemonicToSeed(mnemonic: mnemonicModel.value);
    Digest hashMnemonic = sha256.convert(seed);
    String encryptedHashMnemonic = Aes256.encrypt(pin, hashMnemonic.toString());

    await _settingsRepository.setInitialSetupVisible(value: false);
    await _hashMnemonicRepository.setHashMnemonic(encryptedHashMnemonic.toString());
  }
}
