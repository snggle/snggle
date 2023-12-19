import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/hash/hmac.dart';

void main() {
  Uint8List actualDataToHash = Uint8List.fromList('SNGGLE'.codeUnits);

  group('Tests of Hmac.process()', () {
    test('Should [return HMAC code] based on SHA512 hash', () {
      // Arrange
      Uint8List actualHmacKey = base64Decode('Qml0Y29pbiBzZWVk');

      // Act
      Uint8List actualHmacResult = Hmac().process(actualHmacKey, actualDataToHash);

      // Assert
      Uint8List expectedHmacResult = base64Decode('pqdUqkCukiOxpD8PyKKpT7knqE9toiW7gLjZ80xZzhhT7SEvI3HIpS6kNzpNz1cB4lGCsCDhkaLm9tI4xyjZhg==');

      expect(actualHmacResult, expectedHmacResult);
    });
  });
}
