import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/hash/ripemd160.dart';

void main() {
  Uint8List actualDataToHash = Uint8List.fromList('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~'.codeUnits);

  group('Tests of Ripemd160.process()', () {
    test('Should [return Ripemd160 HASH] constructed from given data', () {
      // Arrange
      Ripemd160 actualRipemd160 = Ripemd160();

      // Act
      Uint8List actualRipemd160Result = actualRipemd160.process(actualDataToHash);

      // Assert
      Uint8List expectedRipemd160Result = base64Decode('iJS43Wf/c7ZqtImU2HYR0laE3q4=');

      expect(actualRipemd160Result, expectedRipemd160Result);
    });
  });
}
