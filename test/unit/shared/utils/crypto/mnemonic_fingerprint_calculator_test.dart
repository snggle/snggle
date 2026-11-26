import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/predefined_network_templates.dart';
import 'package:snggle/shared/utils/crypto/mnemonic_fingerprint_calculator.dart';

void main() {
  group('Tests of MnemonicFingerprintCalculator.calc()', () {
    test('Should [return fingerprint] for given Mnemonic', () async {
      // Arrange
      Mnemonic actualMnemonic = Mnemonic.fromMnemonicPhrase('carry pave input birth pole vague elephant moment either science food donkey');

      // Act
      String actualFingerprint = await MnemonicFingerprintCalculator.calc(actualMnemonic);

      // Assert
      String expectedFingerprint = '1881575369';

      expect(actualFingerprint, expectedFingerprint);
    });
    test('Should [return the same fingerprint as legacy implementation] for 12-word Mnemonic', () async {
      // Arrange
      Mnemonic actualMnemonic = Mnemonic.generate(
        mnemonicSize: MnemonicSize.words12,
      );

      // Act
      String actualFingerprint = await MnemonicFingerprintCalculator.calc(actualMnemonic);

      // Assert
      AHDWallet expectedHDWallet = await PredefinedNetworkTemplates.ethereum.deriveWallet(
        actualMnemonic,
        "m/44'/60'/0'",
      );

      String expectedFingerprint = expectedHDWallet.privateKey.metadata.fingerprint.toString();

      expect(actualFingerprint, expectedFingerprint);
    });

    test('Should [return the same fingerprint as legacy implementation] for 12-word Mnemonic', () async {
      // Arrange
      Mnemonic actualMnemonic = Mnemonic.generate(
        mnemonicSize: MnemonicSize.words12,
      );

      // Act
      String actualFingerprint = await MnemonicFingerprintCalculator.calc(actualMnemonic);

      // Assert
      AHDWallet expectedHDWallet = await PredefinedNetworkTemplates.ethereum.deriveWallet(
        actualMnemonic,
        "m/44'/60'/0'",
      );

      String expectedFingerprint = expectedHDWallet.privateKey.metadata.fingerprint.toString();

      expect(actualFingerprint, expectedFingerprint);
    });
  });


}
