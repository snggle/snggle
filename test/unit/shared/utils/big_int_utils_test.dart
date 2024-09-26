import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/big_int_utils.dart';

void main() {
  group('Tests of BigIntUtils.decode()', () {
    test('Should [return BigInt] constructed from given [Endian.big bytes]', () {
      // Arrange
      List<int> actualBytes = base64Decode('SZYC0g==');

      // Act
      BigInt actualBigInt = BigIntUtils.decode(actualBytes);

      // Assert
      BigInt expectedBigInt = BigInt.parse('1234567890');

      expect(actualBigInt, expectedBigInt);
    });

    test('Should [return BigInt] constructed from given [Endian.little bytes]', () {
      // Arrange
      List<int> actualBytes = base64Decode('SZYC0g==');

      // Act
      BigInt actualBigInt = BigIntUtils.decode(actualBytes, order: Endian.little);

      // Assert
      BigInt expectedBigInt = BigInt.parse('3523384905');

      expect(actualBigInt, expectedBigInt);
    });
  });
}
