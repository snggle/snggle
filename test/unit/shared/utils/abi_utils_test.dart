import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/models/abi_chunk_type.dart';
import 'package:snggle/shared/utils/abi_utils.dart';

void main() {
  group('Tests of AbiUtils.splitIntoChunks()', () {
    test('Should [return ABI chunks] if [length EQUAL 32]', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x00000000000000000000000053bf0a18754873a8102625d8225af6a15a43423c');

      // Act
      List<Uint8List> actualChunks = AbiUtils.splitIntoChunks(actualBytes);

      // Assert
      List<Uint8List> expectedChunks = <Uint8List>[
        HexCodec.decode('0x00000000000000000000000053bf0a18754873a8102625d8225af6a15a43423c'),
      ];

      expect(actualChunks, expectedChunks);
    });

    test('Should [return ABI chunks] if [length MULTIPLY OF 32]', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode(
        '0x00000000000000000000000053bf0a18754873a8102625d8225af6a15a43423c00000000000000000000000053bf0a18754873a8102625d8225af6a15a43423c',
      );

      // Act
      List<Uint8List> actualChunks = AbiUtils.splitIntoChunks(actualBytes);

      // Assert
      List<Uint8List> expectedChunks = <Uint8List>[
        HexCodec.decode('0x00000000000000000000000053bf0a18754873a8102625d8225af6a15a43423c'),
        HexCodec.decode('0x00000000000000000000000053bf0a18754873a8102625d8225af6a15a43423c'),
      ];

      expect(actualChunks, expectedChunks);
    });
  });

  group('Tests of AbiChunkType.recognizeChunkType()', () {
    test('Should [return AbiChunkType.text] for human-readable ASCII bytes', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x48656c6c6f20576f726c64210000000000000000000000000000000000000000');

      // Act
      AbiChunkType actualType = AbiUtils.recognizeChunkType(actualBytes);

      // Assert
      AbiChunkType expectedType = AbiChunkType.text;

      expect(actualType, expectedType);
    });

    test('Should [return AbiChunkType.address] for Ethereum address bytes', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x00000000000000000000000053bf0a18754873a8102625d8225af6a15a43423c');

      // Act
      AbiChunkType actualType = AbiUtils.recognizeChunkType(actualBytes);

      // Assert
      AbiChunkType expectedType = AbiChunkType.address;

      expect(actualType, expectedType);
    });

    test('Should [return AbiChunkType.hex] for any other bytes', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x1231231231231231231231231231231231231231231231231231231231231231');

      // Act
      AbiChunkType actualType = AbiUtils.recognizeChunkType(actualBytes);

      // Assert
      AbiChunkType expectedType = AbiChunkType.hex;

      expect(actualType, expectedType);
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
    test('Should [return number] decoded from given bytes', () {
      // Arrange
      Uint8List actualBytes = HexCodec.decode('0x0000000000000000000000000000000000000000000000000000000000000001');

      // Act
      String? actualNumber = AbiUtils.parseChunkToNumber(actualBytes);

      // Assert
      String expectedNumber = '1';

      expect(actualNumber, expectedNumber);
    });
  });

  group('Tests of AbiUtils.parseChunkToString()', () {
    test('Should [return string] decoded from given bytes', () {
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
}
