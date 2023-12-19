import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/hash/sha256.dart';

void main() {
  Uint8List actualDataToHash = Uint8List.fromList('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~'.codeUnits);

  group('Tests of Sha256.process()', () {
    test('Should [return Sha256 HASH] constructed from given data', () {
      // Arrange
      Sha256 actualSha256 = Sha256();

      // Act
      Uint8List actualSha256Result = actualSha256.process(actualDataToHash);

      // Assert
      Uint8List expectedSha256Result = base64Decode('3wD7XtFKJSyhir71QWYpVt043ekXhh67rrDyHE+EsiQ=');

      expect(actualSha256Result, expectedSha256Result);
    });
  });
}