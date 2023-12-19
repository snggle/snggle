import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/encoding/base/base58.dart';

void main() {
  group('Tests of Base58.encode()', () {
    test('Should [return String] encoded by Base58', () {
      // Arrange
      Uint8List actualDataToEncode = Uint8List.fromList('SNGGLE'.codeUnits);

      // Act
      String actualBase58Result = Base58.encode(actualDataToEncode);

      // Assert
      String expectedBase58Result = 'iV4eZdxG';

      expect(actualBase58Result, expectedBase58Result);
    });

    test('Should [return String] encoded by Base58 (with checksum)', () {
      // Arrange
      Uint8List actualDataToEncode = Uint8List.fromList('SNGGLE'.codeUnits);

      // Act
      String actualBase58Result = Base58.encodeWithChecksum(actualDataToEncode);

      // Assert
      String expectedBase58Result = '5gTRnV2gQkDLq1';

      expect(actualBase58Result, expectedBase58Result);
    });
  });
}