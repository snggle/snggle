import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/hash/keccak.dart';

void main() {
  Uint8List actualDataToHash = Uint8List.fromList('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~'.codeUnits);

  group('Tests of Keccak.process()', () {
    test('Should [return Keccak128 HASH] constructed from given data', () {
      // Arrange
      Keccak actualKeccak = Keccak(128);

      // Act
      Uint8List actualKeccakResult = actualKeccak.process(actualDataToHash);

      // Assert
      Uint8List expectedKeccakResult = base64Decode('2Rbrmj3BGkVcYzxWf3zQhw==');

      expect(actualKeccakResult, expectedKeccakResult);
    });

    test('Should [return Keccak224 HASH] constructed from given data', () {
      // Arrange
      Keccak actualKeccak = Keccak(224);

      // Act
      Uint8List actualKeccakResult = actualKeccak.process(actualDataToHash);

      // Assert
      Uint8List expectedKeccakResult = base64Decode('h3ZKJczNIEckiGE1zv38YNvm9Lig+oYr2fiGAg==');

      expect(actualKeccakResult, expectedKeccakResult);
    });

    test('Should [return Keccak256 HASH] constructed from given data', () {
      // Arrange
      Keccak actualKeccak = Keccak(256);

      // Act
      Uint8List actualKeccakResult = actualKeccak.process(actualDataToHash);

      // Assert
      Uint8List expectedKeccakResult = base64Decode('BCh2dEOFXrYvTet6a/a3PPmwZvQ7KQb60c8ib9WqhfE=');

      expect(actualKeccakResult, expectedKeccakResult);
    });

    test('Should [return Keccak288 HASH] constructed from given data', () {
      // Arrange
      Keccak actualKeccak = Keccak(288);

      // Act
      Uint8List actualKeccakResult = actualKeccak.process(actualDataToHash);

      // Assert
      Uint8List expectedKeccakResult = base64Decode('KPDYH5BgWlRRteR9Hm+lL8Tmv7krLpj/pABDV53+vY3azshS');

      expect(actualKeccakResult, expectedKeccakResult);
    });

    test('Should [return Keccak384 HASH] constructed from given data', () {
      // Arrange
      Keccak actualKeccak = Keccak(384);

      // Act
      Uint8List actualKeccakResult = actualKeccak.process(actualDataToHash);

      // Assert
      Uint8List expectedKeccakResult = base64Decode('hK/d5Vo4YuG2z90PuXxsXahV1Wk7OTB2Tv7IGkPNmScppcbc0z81cdCuG62GWZ9h');

      expect(actualKeccakResult, expectedKeccakResult);
    });

    test('Should [return Keccak512 HASH] constructed from given data', () {
      // Arrange
      Keccak actualKeccak = Keccak(512);

      // Act
      Uint8List actualKeccakResult = actualKeccak.process(actualDataToHash);

      // Assert
      Uint8List expectedKeccakResult = base64Decode('jlBELCX09gYSS5Io1R2gRyLi55O9uFl5d2GyjffXA6WFbUhPlLQyZ/W4ifqpD/CntMJrcvL3VUFuO3Xck/A6Og==');

      expect(actualKeccakResult, expectedKeccakResult);
    });
  });
}
