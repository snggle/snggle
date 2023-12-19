import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/encoding/hex/hex.dart';

void main() {
  Uint8List asciiCodeBytes = Uint8List.fromList('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~'.codeUnits);
  String hexLowercase =
      '3132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e';
  String hexUppercase =
      '3132333435363738393A3B3C3D3E3F404142434445464748494A4B4C4D4E4F505152535455565758595A5B5D5E5F606162636465666768696A6B6C6D6E6F707172737475767778797A7B7C7D7E';

  group('Tests of Hex.encode()', () {
    test('Should [return UPPERCASE hexadecimal] from given bytes', () {
      Uint8List actualDataToEncode = asciiCodeBytes;

      // Act
      String actualHexResult = Hex().encode(actualDataToEncode, lowercaseBool: false);

      // Assert
      String expectedHexResult = hexUppercase;

      expect(actualHexResult, expectedHexResult);
    });

    test('Should [return LOWERCASE hexadecimal] from given bytes', () {
      Uint8List actualDataToEncode = asciiCodeBytes;

      // Act
      String actualHexResult = Hex().encode(actualDataToEncode, lowercaseBool: true);

      // Assert
      String expectedHexResult = hexLowercase;

      expect(actualHexResult, expectedHexResult);
    });
  });

  group('Tests of Hex.decode()', () {
    test('Should [return Uint8List] decoded from given [UPPERCASE hexadecimal]', () {
      // Arrange
      String actualHexToDecode = hexUppercase;

      // Act
      Uint8List actualDecodedHexResult = Hex().decode(actualHexToDecode);

      // Assert
      Uint8List expectedDecodedHexResult = asciiCodeBytes;

      expect(actualDecodedHexResult, expectedDecodedHexResult);
    });

    test('Should [return Uint8List] decoded from given [LOWERCASE hexadecimal]', () {
      // Arrange
      String actualHexToDecode = hexLowercase;

      // Act
      Uint8List actualDecodedHexResult = Hex().decode(actualHexToDecode);

      // Assert
      Uint8List expectedDecodedHexResult = asciiCodeBytes;

      expect(actualDecodedHexResult, expectedDecodedHexResult);
    });
  });
}
