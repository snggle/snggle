import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/encoding/bech32/segwit_bech32_encoder.dart';

void main() {
  group('Tests of SegwitBech32Encoder.encode()', () {
    test('Should [return String] encoded by Bech32 (Segwit version)', () {
      // Arrange
      Uint8List actualDataToEncode = base64Decode('KxmiVli7oFEs8N5rjnzLtw7eym0=');

      // Act
      String actualEncodedData = SegwitBech32Encoder.encode('snggle', 0, actualDataToEncode);

      // Assert
      String expectedEncodedData = 'snggle1q9vv6y4jchws9zt8sme4culxtku8dajndszqgl6';

      expect(actualEncodedData, expectedEncodedData);
    });
  });
}