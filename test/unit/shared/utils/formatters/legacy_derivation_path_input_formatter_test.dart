import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/formatters/legacy_derivation_path_input_formatter.dart';

void main() {
  group('Tests of LegacyDerivationPathInputFormatter.formatEditUpdate()', () {
    test('Should [return NEW VALUE] if [new value EMPTY]', () {
      // Arrange
      LegacyDerivationPathInputFormatter actualLegacyDerivationPathInputFormatter = LegacyDerivationPathInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualLegacyDerivationPathInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '44', selection: TextSelection(baseOffset: 2, extentOffset: 2)),
        const TextEditingValue(text: '', selection: TextSelection(baseOffset: 0, extentOffset: 0)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '', selection: TextSelection(baseOffset: 0, extentOffset: 0));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return NEW VALUE] if [new value VALID]', () {
      // Arrange
      LegacyDerivationPathInputFormatter actualLegacyDerivationPathInputFormatter = LegacyDerivationPathInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualLegacyDerivationPathInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '44', selection: TextSelection(baseOffset: 2, extentOffset: 2)),
        const TextEditingValue(text: '123', selection: TextSelection(baseOffset: 3, extentOffset: 3)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '123', selection: TextSelection(baseOffset: 3, extentOffset: 3));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD VALUE] if [new value STARTS WITH 00]', () {
      // Arrange
      LegacyDerivationPathInputFormatter actualLegacyDerivationPathInputFormatter = LegacyDerivationPathInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualLegacyDerivationPathInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '0', selection: TextSelection(baseOffset: 1, extentOffset: 1)),
        const TextEditingValue(text: '00123', selection: TextSelection(baseOffset: 5, extentOffset: 5)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '0', selection: TextSelection(baseOffset: 1, extentOffset: 1));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD VALUE] if [new value NOT NUMBER]', () {
      // Arrange
      LegacyDerivationPathInputFormatter actualLegacyDerivationPathInputFormatter = LegacyDerivationPathInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualLegacyDerivationPathInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '0', selection: TextSelection(baseOffset: 1, extentOffset: 1)),
        const TextEditingValue(text: '0a', selection: TextSelection(baseOffset: 2, extentOffset: 2)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '0', selection: TextSelection(baseOffset: 1, extentOffset: 1));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD VALUE] if [new value > 2147483647]', () {
      // Arrange
      LegacyDerivationPathInputFormatter actualLegacyDerivationPathInputFormatter = LegacyDerivationPathInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualLegacyDerivationPathInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '0', selection: TextSelection(baseOffset: 1, extentOffset: 1)),
        const TextEditingValue(text: '2147483648', selection: TextSelection(baseOffset: 10, extentOffset: 10)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '0', selection: TextSelection(baseOffset: 1, extentOffset: 1));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });
  });
}
