import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/derivation_path_index_extractor.dart';

void main() {
  group('Tests of DerivationPathIndexExtractor.extractIndex()', () {
    test('Should [extract index] from a derivation path template with a HARDENED dynamic element', () {
      // Arrange
      String actualDerivationPathTemplate = "m/44'/501'/{{i}}'/0'";
      String actualDerivationPath = "m/44'/501'/2'/0'";
      DerivationPathIndexExtractor actualDerivationPathIndexExtractor =
          DerivationPathIndexExtractor(derivationPathTemplate: actualDerivationPathTemplate);

      // Act
      int actualDerivationIndex = actualDerivationPathIndexExtractor.extractIndex(actualDerivationPath);

      // Assert
      int expectedDerivationIndex = 2;

      expect(actualDerivationIndex, expectedDerivationIndex);
    });

    test('Should [extract index] from a derivation path template with an UNHARDENED dynamic element', () {
      // Arrange
      String actualDerivationPathTemplate = "m/44'/60'/0'/0/{{i}}";
      String actualDerivationPath = "m/44'/60'/0'/0/2";
      DerivationPathIndexExtractor actualDerivationPathIndexExtractor =
          DerivationPathIndexExtractor(derivationPathTemplate: actualDerivationPathTemplate);

      // Act
      int actualDerivationIndex = actualDerivationPathIndexExtractor.extractIndex(actualDerivationPath);

      // Assert
      int expectedDerivationIndex = 2;

      expect(actualDerivationIndex, expectedDerivationIndex);
    });

    test('Should [throw FormatException] when a derivation path template has NO dynamic element', () {
      // Arrange
      String actualDerivationPathTemplate = "m/44'/60'/0'/0/0";
      String actualDerivationPath = "m/44'/60'/0'/0/0";
      DerivationPathIndexExtractor actualDerivationPathIndexExtractor =
          DerivationPathIndexExtractor(derivationPathTemplate: actualDerivationPathTemplate);

      // Assert
      expect(() => actualDerivationPathIndexExtractor.extractIndex(actualDerivationPath), throwsA(isA<FormatException>()));
    });

    test('Should [throw FormatException] when derivation path is TOO SHORT for the derivation path template', () {
      // Arrange
      String actualDerivationPathTemplate = "m/44'/60'/0'/0/{{i}}";
      String actualDerivationPath = "m/44'";
      DerivationPathIndexExtractor actualDerivationPathIndexExtractor =
          DerivationPathIndexExtractor(derivationPathTemplate: actualDerivationPathTemplate);

      // Assert
      expect(() => actualDerivationPathIndexExtractor.extractIndex(actualDerivationPath), throwsA(isA<FormatException>()));
    });
  });
}
