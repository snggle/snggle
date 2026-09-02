import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/formatters/custom_password_length_input_formatter.dart';

void main() {
  group('Tests of CustomPasswordLengthInputFormatter.formatEditUpdate()', () {
    test('Should [return NEW VALUE] if [new value EMPTY]', () {
      // Arrange
      CustomPasswordLengthInputFormatter actualCustomPasswordLengthInputFormatter = CustomPasswordLengthInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '5', selection: TextSelection(baseOffset: 1, extentOffset: 1)),
        const TextEditingValue(text: '', selection: TextSelection(baseOffset: 0, extentOffset: 0)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '', selection: TextSelection(baseOffset: 0, extentOffset: 0));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return NEW VALUE] if [new value < 256]', () {
      // Arrange
      CustomPasswordLengthInputFormatter actualCustomPasswordLengthInputFormatter = CustomPasswordLengthInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '15', selection: TextSelection(baseOffset: 2, extentOffset: 2)),
        const TextEditingValue(text: '150', selection: TextSelection(baseOffset: 3, extentOffset: 3)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '150', selection: TextSelection(baseOffset: 3, extentOffset: 3));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD VALUE] if [new value > 256]', () {
      // Arrange
      CustomPasswordLengthInputFormatter actualCustomPasswordLengthInputFormatter = CustomPasswordLengthInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '25', selection: TextSelection(baseOffset: 2, extentOffset: 2)),
        const TextEditingValue(text: '257', selection: TextSelection(baseOffset: 3, extentOffset: 3)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection(baseOffset: 2, extentOffset: 2));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD VALUE] if [new value STARTS WITH 0]', () {
      // Arrange
      CustomPasswordLengthInputFormatter actualCustomPasswordLengthInputFormatter = CustomPasswordLengthInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '', selection: TextSelection(baseOffset: 0, extentOffset: 0)),
        const TextEditingValue(text: '0', selection: TextSelection(baseOffset: 1, extentOffset: 1)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '', selection: TextSelection(baseOffset: 0, extentOffset: 0));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD VALUE] if [new value NOT NUMBER]', () {
      // Arrange
      CustomPasswordLengthInputFormatter actualCustomPasswordLengthInputFormatter = CustomPasswordLengthInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '', selection: TextSelection(baseOffset: 0, extentOffset: 0)),
        const TextEditingValue(text: 'a', selection: TextSelection(baseOffset: 1, extentOffset: 1)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '', selection: TextSelection(baseOffset: 0, extentOffset: 0));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });
  });
}
