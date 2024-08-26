import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/formatters/legacy_derivation_path_input_formatter.dart';

void main() {
  group('Tests of LegacyDerivationPathInputFormatter.formatEditUpdate()', () {
    test('Should [return NEW VALUE] if [input VALID]', () {
      // Arrange
      LegacyDerivationPathInputFormatter actualLegacyDerivationPathInputFormatter = LegacyDerivationPathInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualLegacyDerivationPathInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '44', selection: TextSelection(baseOffset: 2, extentOffset: 2)),
        const TextEditingValue(text: "44'/60", selection: TextSelection(baseOffset: 6, extentOffset: 6)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: "44'/60", selection: TextSelection(baseOffset: 6, extentOffset: 6));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });

    test('Should [return OLD VALUE] if [input INVALID]', () {
      // Arrange
      LegacyDerivationPathInputFormatter actualLegacyDerivationPathInputFormatter = LegacyDerivationPathInputFormatter();

      // Act
      TextEditingValue actualTextEditingValue = actualLegacyDerivationPathInputFormatter.formatEditUpdate(
        const TextEditingValue(text: '44', selection: TextSelection(baseOffset: 2, extentOffset: 2)),
        const TextEditingValue(text: "44'////60'", selection: TextSelection(baseOffset: 10, extentOffset: 10)),
      );

      // Assert
      TextEditingValue expectedTextEditingValue = const TextEditingValue(text: '44', selection: TextSelection(baseOffset: 2, extentOffset: 2));

      expect(actualTextEditingValue, expectedTextEditingValue);
    });
  });

  group('Tests of LegacyDerivationPathInputFormatter.hasMatch()', () {
    group('Tests for VALID cases', () {
      test('Should [return TRUE] for EMPTY STRING', () {
        expect(LegacyDerivationPathInputFormatter.hasMatch(''), true);
      });

      test('Should [return TRUE] for 44', () {
        expect(LegacyDerivationPathInputFormatter.hasMatch('44'), true);
      });

      test('Should [return TRUE] for 44/', () {
        expect(LegacyDerivationPathInputFormatter.hasMatch('44/'), true);
      });

      test("Should [return TRUE] for 44'", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("44'"), true);
      });

      test("Should [return TRUE] for 44'/", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("44'/"), true);
      });

      test("Should [return TRUE] for 44'/44", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("44'/44"), true);
      });

      test("Should [return TRUE] for 44'/44/", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("44'/44/"), true);
      });

      test("Should [return TRUE] for 44'/44/44444", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("44'/44/44444"), true);
      });
    });

    group('Tests for INVALID cases', () {
      test('Should [return FALSE] for /', () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("'"), false);
      });

      test("Should [return FALSE] for '", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("'"), false);
      });

      test('Should [return FALSE] for 44//', () {
        expect(LegacyDerivationPathInputFormatter.hasMatch('44//'), false);
      });

      test("Should [return FALSE] for 44''", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("44''"), false);
      });

      test("Should [return FALSE] for 44'444'", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("44'444'"), false);
      });

      test("Should [return FALSE] for 44/abc'", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("44/abc'"), false);
      });

      test("Should [return FALSE] for a'", () {
        expect(LegacyDerivationPathInputFormatter.hasMatch("a'"), false);
      });
    });
  });
}
