import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/encoding/bech32/bech32_encoder.dart';

void main() {
  group('Tests of Bech32Encoder.encode()', () {
    test('Should [return String] encoded by Bech32', () {
      // Arrange
      Uint8List actualDataToEncode = base64Decode('KxmiVli7oFEs8N5rjnzLtw7eym0=');

      // Act
      String actualEncodedData = Bech32Encoder.encode('snggle', actualDataToEncode);

      // Assert
      String expectedEncodedData = 'snggle19vv6y4jchws9zt8sme4culxtku8dajnd8remz3';

      expect(actualEncodedData, expectedEncodedData);
    });
  });
}