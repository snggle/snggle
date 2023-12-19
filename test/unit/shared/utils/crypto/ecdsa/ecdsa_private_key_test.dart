import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_private_key.dart';

void main() {
  group('Tests of ECDSAPrivateKey.fromBytes() constructor', () {
    test('Should [return ECDSAPrivateKey] constructed from given bytes (Secp256k1)', () {
      // Act
      ECDSAPrivateKey actualECDSAPrivateKey = ECDSAPrivateKey.fromBytes(
        base64Decode('IxMiv7h+lmU8ouyK8Ds+wP5EL/n1Kv0TKJft3E0Kf8M='),
        Curves.generatorSecp256k1,
      );

      // Assert
      ECDSAPrivateKey expectedECDSAPrivateKey = ECDSAPrivateKey(
        Curves.generatorSecp256k1,
        BigInt.parse('15864759622800253937020257025334897817812874204769186060960403729801414344643'),
      );

      expect(actualECDSAPrivateKey, expectedECDSAPrivateKey);
    });
  });

  group('Tests of ECDSAPrivateKey.bytes getter', () {
    test('Should [return key bytes] from ECDSAPrivateKey (Secp256k1)', (){
      // Arrange
      ECDSAPrivateKey ecdsaPrivateKey = ECDSAPrivateKey(
        Curves.generatorSecp256k1,
        BigInt.parse('15864759622800253937020257025334897817812874204769186060960403729801414344643'),
      );

      // Act
      Uint8List actualPrivateKeyBytes = ecdsaPrivateKey.bytes;

      // Assert
      Uint8List expectedPrivateKeyBytes = base64Decode('IxMiv7h+lmU8ouyK8Ds+wP5EL/n1Kv0TKJft3E0Kf8M=');

      expect(actualPrivateKeyBytes, expectedPrivateKeyBytes);
    });
  });

  group('Tests of ECDSAPrivateKey.length getter', (){
    test('Should [return key length] from ECDSAPrivateKey (Secp256k1)', (){
      // Arrange
      ECDSAPrivateKey ecdsaPrivateKey = ECDSAPrivateKey(
        Curves.generatorSecp256k1,
        BigInt.parse('15864759622800253937020257025334897817812874204769186060960403729801414344643'),
      );

      // Act
      int actualPrivateKeyLength = ecdsaPrivateKey.length;

      // Assert
      int expectedPrivateKeyLength = 32;

      expect(actualPrivateKeyLength, expectedPrivateKeyLength);
    });
  });
}
