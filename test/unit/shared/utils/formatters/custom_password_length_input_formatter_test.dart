import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/formatters/custom_password_length_input_formatter.dart';

void main() {
  late CustomPasswordLengthInputFormatter actualCustomPasswordLengthInputFormatter;

  group('Tests of CustomPasswordLengthInputFormatter.formatEditUpdate()', () {
    setUp(() {
      actualCustomPasswordLengthInputFormatter = CustomPasswordLengthInputFormatter(maximumLength: 256);
    });

    test('Should [return NEW value] if [new value EMPTY]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '5',
        selection: TextSelection.collapsed(offset: 1),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return NEW value] if [new value MINIMUM positive integer]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '1',
        selection: TextSelection.collapsed(offset: 1),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '1',
        selection: TextSelection.collapsed(offset: 1),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return NEW value] if [new value BELOW maximum]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '15',
        selection: TextSelection.collapsed(offset: 2),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '150',
        selection: TextSelection.collapsed(offset: 3),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '150',
        selection: TextSelection.collapsed(offset: 3),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return NEW value] if [new value EQUALS maximum]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '256',
        selection: TextSelection.collapsed(offset: 3),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '256',
        selection: TextSelection.collapsed(offset: 3),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return NEW value] if [digits DELETED]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '2',
        selection: TextSelection.collapsed(offset: 1),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '2',
        selection: TextSelection.collapsed(offset: 1),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [preserve NEW selection and composing range] if [text UNCHANGED]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 1),
        composing: TextRange(start: 0, end: 2),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 1),
        composing: TextRange(start: 0, end: 2),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value ABOVE maximum]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '257',
        selection: TextSelection.collapsed(offset: 3),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value ZERO]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '0',
        selection: TextSelection.collapsed(offset: 1),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value has LEADING ZERO]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '04',
        selection: TextSelection.collapsed(offset: 2),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value NONNUMERIC]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: 'a',
        selection: TextSelection.collapsed(offset: 1),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value NEGATIVE]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '-4',
        selection: TextSelection.collapsed(offset: 2),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 2),
      );

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value has PLUS SIGN]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(text: '+4', selection: TextSelection.collapsed(offset: 2));

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value FRACTIONAL]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(text: '4.5', selection: TextSelection.collapsed(offset: 3));

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value has LEADING WHITESPACE]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(text: ' 4', selection: TextSelection.collapsed(offset: 2));

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value has TRAILING WHITESPACE]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(text: '4 ', selection: TextSelection.collapsed(offset: 2));

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD value] if [new value exceeds INTEGER range]', () {
      // Arrange
      TextEditingValue actualOldTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));
      TextEditingValue actualNewTextEditingValue = const TextEditingValue(
        text: '9999999999999999999999999999999999999999',
        selection: TextSelection.collapsed(offset: 40),
      );

      // Act
      TextEditingValue actualTextEditingValue = actualCustomPasswordLengthInputFormatter.formatEditUpdate(
        actualOldTextEditingValue,
        actualNewTextEditingValue,
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '25', selection: TextSelection.collapsed(offset: 2));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });
  });
}
