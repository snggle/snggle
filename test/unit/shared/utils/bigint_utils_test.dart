import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/big_int_utils.dart';

void main() {
  group('Tests of BigIntUtils.buildFromBytes()', () {
    test('Should [return BigInt] constructed from given bytes', () {
      // Arrange
      List<int> actualBytes = <int>[1, 103, 96, 245, 57, 121, 135, 90, 112, 171, 31, 70, 88];

      // Act
      BigInt actualBigInt = BigIntUtils.buildFromBytes(actualBytes);

      // Assert
      BigInt expectedBigInt = BigInt.parse('111222333444555666777888999000');

      expect(actualBigInt, expectedBigInt);
    });
  });

  group('Tests of BigIntUtils.calculateByteLength()', () {
    test('Should [return number] representing size (in bytes) needed to store given BigInt', () {
      // Arrange
      BigInt actualBigInt = BigInt.parse('111222333444555666777888999000');

      // Act
      int actualByteLength = BigIntUtils.calculateByteLength(actualBigInt);

      // Assert
      int expectedByteLength = 13;

      expect(actualByteLength, expectedByteLength);
    });
  });

  group('Tests of BigIntUtils.changeToBytes()', () {
    test('Should [return bytes] constructed from given BigInt', () {
      // Arrange
      BigInt actualBigInt = BigInt.parse('111222333444555666777888999000');

      // Act
      Uint8List actualBytes = BigIntUtils.changeToBytes(actualBigInt);

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[1, 103, 96, 245, 57, 121, 135, 90, 112, 171, 31, 70, 88]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Tests of BigIntUtils.computeNAF()', () {
    test('Should [return bytes] representing NAF (Non-adjacent form) for given BigInt', () {
      // Arrange
      BigInt actualBigInt = BigInt.parse('123');

      // Act
      List<BigInt> actualNAFList = BigIntUtils.computeNAF(actualBigInt);

      // Assert
      List<BigInt> expectedNAFList = <BigInt>[
        BigInt.parse('-1'),
        BigInt.parse('0'),
        BigInt.parse('-1'),
        BigInt.parse('0'),
        BigInt.parse('0'),
        BigInt.parse('0'),
        BigInt.parse('0'),
        BigInt.parse('1'),
      ];

      expect(actualNAFList, expectedNAFList);
    });
  });
}
