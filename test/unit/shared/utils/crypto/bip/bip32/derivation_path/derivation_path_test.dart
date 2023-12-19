import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path_element.dart';

void main() {
  group('Tests of DerivationPath.parse() constructor', () {
    test('Should [return DerivationPath] object parsed from [VALID derivation path] (without trailing slash)', () {
      // Act
      DerivationPath actualDerivationPath = DerivationPath.parse("m/44'/60'/0'/0/0");

      // Assert
      DerivationPath expectedDerivationPath = DerivationPath(elements: const <DerivationPathElement>[
        DerivationPathElement(hardenedBool: true, index: 44, value: "44'"),
        DerivationPathElement(hardenedBool: true, index: 60, value: "60'"),
        DerivationPathElement(hardenedBool: true, index: 0, value: "0'"),
        DerivationPathElement(hardenedBool: false, index: 0, value: '0'),
        DerivationPathElement(hardenedBool: false, index: 0, value: '0'),
      ]);

      expect(actualDerivationPath, expectedDerivationPath);
    });

    test('Should [return DerivationPath] object parsed from [VALID derivation path] (with trailing slash)', () {
      // Act
      DerivationPath actualDerivationPath = DerivationPath.parse("m/44'/60'/0'/0/0/");

      // Assert
      DerivationPath expectedDerivationPath = DerivationPath(elements: const <DerivationPathElement>[
        DerivationPathElement(hardenedBool: true, index: 44, value: "44'"),
        DerivationPathElement(hardenedBool: true, index: 60, value: "60'"),
        DerivationPathElement(hardenedBool: true, index: 0, value: "0'"),
        DerivationPathElement(hardenedBool: false, index: 0, value: '0'),
        DerivationPathElement(hardenedBool: false, index: 0, value: '0'),
      ]);

      expect(actualDerivationPath, expectedDerivationPath);
    });

    test('Should [throw FormatException] if derivation path does not contain master element', () {
      // Act
      void actualDerivationPath() => DerivationPath.parse("44'/60'/0'/0/0");

      // Assert
      expect(actualDerivationPath, throwsFormatException);
    });

    test('Should [throw FormatException] if derivation path is empty', () {
      // Act
      void actualDerivationPath() => DerivationPath.parse('');

      // Assert
      expect(actualDerivationPath, throwsFormatException);
    });
  });

  group('Tests of DerivationPath.toString()', () {
    test('Should [stringify DerivationPath]', () {
      // Arrange
      DerivationPath actualDerivationPath = DerivationPath(elements: const <DerivationPathElement>[
        DerivationPathElement(hardenedBool: true, index: 44, value: "44'"),
        DerivationPathElement(hardenedBool: true, index: 60, value: "60'"),
        DerivationPathElement(hardenedBool: true, index: 0, value: "0'"),
        DerivationPathElement(hardenedBool: false, index: 0, value: '0'),
        DerivationPathElement(hardenedBool: false, index: 0, value: '0'),
      ]);

      // Act
      String actualDerivationPathString = actualDerivationPath.toString();

      // Assert
      String expectedDerivationPathString = "m/44'/60'/0'/0/0";

      expect(actualDerivationPathString, expectedDerivationPathString);
    });
  });
}
