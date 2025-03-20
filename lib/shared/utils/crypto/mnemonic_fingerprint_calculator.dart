import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography_utils/cryptography_utils.dart';

class MnemonicFingerprintCalculator {
  static Future<String> calc(Mnemonic mnemonic) async {
    LegacyMnemonicSeedGenerator legacyMnemonicSeedGenerator = LegacyMnemonicSeedGenerator();
    Uint8List seed = await legacyMnemonicSeedGenerator.generateSeed(mnemonic);
    return base64Encode(Sha256().convert(seed).byteList);
  }
}
