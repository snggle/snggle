import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path_element.dart';

void main() {
  group('Tests of DerivationPathElement.parse() constructor', (){
    test('Should [return DerivationPathElement] from [HARDENED path element as String]', () {
      // Act
      DerivationPathElement actualDerivationPathElement = DerivationPathElement.parse("44'");

      // Assert
      DerivationPathElement expectedDerivationPathElement = const DerivationPathElement(hardenedBool: true, index: 44, value: "44'");

      expect(actualDerivationPathElement, expectedDerivationPathElement);
    });

    test('Should [return DerivationPathElement] from [NOT HARDENED path element as String]', () {
      // Act
      DerivationPathElement actualDerivationPathElement = DerivationPathElement.parse('0');

      // Assert
      DerivationPathElement expectedDerivationPathElement = const DerivationPathElement(hardenedBool: false, index: 0, value: '0');

      expect(actualDerivationPathElement, expectedDerivationPathElement);
    });

    test('Should [throw FormatException] if provided [path element INVALID]', () {
      // Act
      void actualDerivationPathElement() => DerivationPathElement.parse('0x');

      // Assert
      expect(actualDerivationPathElement, throwsFormatException);
    });
  });

  group('Tests of DerivationPathElement.isHardened getter', (){
    test('Should [return TRUE] if [path element HARDENED]', () {
      // Arrange
      DerivationPathElement derivationPathElement = const DerivationPathElement(hardenedBool: true, index: 0, value: "0'");

      // Act
      bool actualHardenedBool = derivationPathElement.isHardened;

      // Assert
      expect(actualHardenedBool, true);
    });

    test('Should [return FALSE] if [path element NOT HARDENED]', () {
      // Arrange
      DerivationPathElement derivationPathElement = const DerivationPathElement(hardenedBool: false, index: 0, value: '0');

      // Act
      bool actualHardenedBool = derivationPathElement.isHardened;

      // Assert
      expect(actualHardenedBool, false);
    });
  });

  group('Tests of DerivationPathElement.toBytes()', (){
    test('Should [return BYTES] constructed from DerivationPathElement index (zero value)', (){
      // Arrange
      DerivationPathElement derivationPathElement = const DerivationPathElement(hardenedBool: false, index: 0, value: '0');

      // Act
      List<int> actualBytes = derivationPathElement.toBytes();

      // Assert
      List<int> expectedBytes = <int>[0, 0, 0, 0];
      expect(actualBytes, expectedBytes);
    });

    test('Should [return BYTES] constructed from DerivationPathElement index (non-zero value)', (){
      // Arrange
      DerivationPathElement derivationPathElement = const DerivationPathElement(hardenedBool: false, index: 44, value: '44');

      // Act
      List<int> actualBytes = derivationPathElement.toBytes();

      // Assert
      List<int> expectedBytes = <int>[0, 0, 0, 44];
      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of DerivationPathElement.toString()', (){
    test('Should [stringify DerivationPathElement] (path element NOT HARDENED) ', (){
      // Arrange
      DerivationPathElement derivationPathElement = const DerivationPathElement(hardenedBool: false, index: 44, value: '44');

      // Act
      String actualString = derivationPathElement.toString();

      // Assert
      String expectedString = '44';
      expect(actualString, expectedString);
    });

    test('Should [stringify DerivationPathElement] (path element HARDENED) ', (){
      // Arrange
      DerivationPathElement derivationPathElement = const DerivationPathElement(hardenedBool: true, index: 44, value: "44'");

      // Act
      String actualString = derivationPathElement.toString();

      // Assert
      String expectedString = "44'";
      expect(actualString, expectedString);
    });
  });
}