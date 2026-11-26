import 'package:cryptography_utils/cryptography_utils.dart';

class MnemonicFingerprintCalculator {
  static Future<String> calc(Mnemonic mnemonic) async {
    LegacyDerivationPath derivationPath =
    LegacyDerivationPath.parse("m/44'/60'/0'");

    Secp256k1PrivateKey privateKey =
    await Secp256k1Derivator().derivePath(
      mnemonic,
      derivationPath,
    );

    return privateKey.metadata.fingerprint.toString();
  }
}
