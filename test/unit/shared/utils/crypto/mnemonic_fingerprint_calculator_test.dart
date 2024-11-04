import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/mnemonic_fingerprint_calculator.dart';

void main() {
  group('Tests of MnemonicFingerprintCalculator.calc()', () {
    test('Should [return fingerprint] for given Mnemonic', () async {
      // Arrange
      Mnemonic actualMnemonic = Mnemonic.fromMnemonicPhrase('carry pave input birth pole vague elephant moment either science food donkey');

      // Act
      String actualFingerprint = await MnemonicFingerprintCalculator.calc(actualMnemonic);

      // Assert
      String expectedFingerprint = 'Lki3oJlA8rXrJiViEZG3RSqGobYXZ+ki4kGabkZl/rk=';

      expect(actualFingerprint, expectedFingerprint);
    });
  });
}
