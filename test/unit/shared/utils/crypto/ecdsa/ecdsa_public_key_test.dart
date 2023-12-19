import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

void main() {
  group('Tests of ECDSAPublicKey.compressed getter', () {
    test('Should [return bytes] representing [COMPRESSED ECDSAPublicKey] (Secp256k1)', (){
      // Arrange
      ECDSAPublicKey ecdsaPublicKey = ECDSAPublicKey(
        Curves.generatorSecp256k1,
        ECPoint(
          x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
          y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
          z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
          n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
          curve: Curves.curveSecp256k1,
        ),
      );

      // Act
      Uint8List actualCompressedPublicKey = ecdsaPublicKey.compressed;

      // Assert
      Uint8List expectedCompressedPublicKey = base64Decode('Ar+tLoQUarMHBlWt2YHvheCerhvBi3VacJya8XNUx2Yj');

      expect(actualCompressedPublicKey, expectedCompressedPublicKey);
    });

    test('Should [return bytes] representing [UNCOMPRESSED ECDSAPublicKey] (Secp256k1)', (){
      // Assert
      ECDSAPublicKey ecdsaPublicKey = ECDSAPublicKey(
        Curves.generatorSecp256k1,
        ECPoint(
          x: BigInt.parse('109809582697629541179477143463768131161650648020283737506803606109779771350309'),
          y: BigInt.parse('93904199375389538639503047221917403320671286887529822165996195593332713512966'),
          z: BigInt.parse('15114296647857780461657875995579731758281183768828053400819025202844531705682'),
          n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
          curve: Curves.curveSecp256k1,
        ),
      );

      // Act
      Uint8List actualUncompressedPublicKey = ecdsaPublicKey.uncompressed;

      // Assert
      Uint8List expectedUncompressedPublicKey = base64Decode('BL+tLoQUarMHBlWt2YHvheCerhvBi3VacJya8XNUx2YjRdh4yvIJvEV4shNwcx/bJI+WUme3DGfy1SuRlBmPA4o=');

      expect(actualUncompressedPublicKey, expectedUncompressedPublicKey);
    });
  });
}