import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/abi_utils.dart';

void main() {
  group('Tests of AbiUtils.parseChunkToString()', () {
    test('Should [return Ethereum address] decoded from given bytes', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x48656c6c6f20576f726c64210000000000000000000000000000000000000000');

      // Act
      String? actualText = AbiUtils.parseChunkToString(actualBytes);

      // Assert
      String expectedText = 'Hello World!';

      expect(actualText, expectedText);
    });

    test('Should [return NULL] if given bytes is not an Ethereum address', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x0000000000000000000000000000000000000000000000000000000000000123');

      // Act
      String? actualText = AbiUtils.parseChunkToString(actualBytes);

      // Assert
      expect(actualText, null);
    });
  });

  group('Tests of AbiUtils.parseChunkToAddress()', () {
    test('Should [return Ethereum address] decoded from given bytes', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x00000000000000000000000053bf0a18754873a8102625d8225af6a15a43423c');

      // Act
      String? actualAddress = AbiUtils.parseChunkToAddress(actualBytes);

      // Assert
      String expectedAddress = '0x53bf0a18754873a8102625d8225af6a15a43423c';

      expect(actualAddress, expectedAddress);
    });

    test('Should [return NULL] if given bytes are longer than expected Ethereum address bytes', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x1231231231231231231231231231231231231231231231231231231231231231');

      // Act
      String? actualAddress = AbiUtils.parseChunkToAddress(actualBytes);

      // Assert
      expect(actualAddress, null);
    });
  });

  group('Tests of AbiUtils.parseChunkToNumber()', () {
    test('Should [return Ethereum address] decoded from given bytes', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x0000000000000000000000000000000000000000000000000000000000000001');

      // Act
      String? actualNumber = AbiUtils.parseChunkToNumber(actualBytes);

      // Assert
      String expectedNumber = '1';

      expect(actualNumber, expectedNumber);
    });
  });
}
