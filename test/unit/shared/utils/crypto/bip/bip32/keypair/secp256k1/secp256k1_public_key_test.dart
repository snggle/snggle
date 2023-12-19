import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/extended_private_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

void main() {
  group('Tests of Secp256k1PublicKey.fromExtendedPrivateKey() constructor', () {
    test('Should [return Secp256k1PublicKey] constructed from ExtendedPrivateKey', () {
      // Arrange
      ExtendedPrivateKey actualExtendedPrivateKey = ExtendedPrivateKey(
        privateKeyBytes: base64Decode('IxMiv7h+lmU8ouyK8Ds+wP5EL/n1Kv0TKJft3E0Kf8M='),
        chainCodeBytes: base64Decode('UNH2aBl1uMkP+S/i5vZVK8tC2uODdICFW0hrpY8Zrbk='),
      );

      // Act
      Secp256k1PublicKey actualSecp256k1PublicKey = Secp256k1PublicKey.fromExtendedPrivateKey(actualExtendedPrivateKey);

      // Assert
      Secp256k1PublicKey expectedSecp256k1PublicKey = Secp256k1PublicKey(
        ecdsaPublicKey: ECDSAPublicKey(
          Curves.generatorSecp256k1,
          ECPoint(
            x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
            y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
            z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
            n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
            curve: Curves.curveSecp256k1,
          ),
        ),
      );

      expect(actualSecp256k1PublicKey, expectedSecp256k1PublicKey);
    });
  });

  group('Tests of Secp256k1PublicKey.compressed getter', (){
    test('Should [return bytes] representing [COMPRESSED Secp256k1PublicKey]', () {
      // Arrange
      Secp256k1PublicKey secp256k1publicKey = Secp256k1PublicKey(
        ecdsaPublicKey: ECDSAPublicKey(
          Curves.generatorSecp256k1,
          ECPoint(
            x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
            y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
            z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
            n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
            curve: Curves.curveSecp256k1,
          ),
        ),
      );

      // Act
      Uint8List actualCompressedPublicKey = secp256k1publicKey.compressed;

      // Assert
      Uint8List expectedCompressedPublicKey = base64Decode('Ar+tLoQUarMHBlWt2YHvheCerhvBi3VacJya8XNUx2Yj');

      expect(actualCompressedPublicKey, expectedCompressedPublicKey);
    });
  });

  group('Tests of Secp256k1PublicKey.uncompressed getter', (){
    test('Should [return bytes] representing [UNCOMPRESSED Secp256k1PublicKey]', () {
      // Arrange
      Secp256k1PublicKey secp256k1publicKey = Secp256k1PublicKey(
        ecdsaPublicKey: ECDSAPublicKey(
          Curves.generatorSecp256k1,
          ECPoint(
            x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
            y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
            z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
            n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
            curve: Curves.curveSecp256k1,
          ),
        ),
      );

      // Act
      Uint8List actualCompressedPublicKey = secp256k1publicKey.uncompressed;

      // Assert
      Uint8List expectedCompressedPublicKey = base64Decode('BL+tLoQUarMHBlWt2YHvheCerhvBi3VacJya8XNUx2YjRdh4yvIJvEV4shNwcx/bJI+WUme3DGfy1SuRlBmPA4o=');

      expect(actualCompressedPublicKey, expectedCompressedPublicKey);
    });
  });
}