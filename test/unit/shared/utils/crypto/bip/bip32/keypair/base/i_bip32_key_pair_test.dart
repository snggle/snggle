import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_key_pair.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_key_pair.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_private_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve_type.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_private_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

void main() {
  group('Tests of IBip32KeyPair.derive()', () {
    test('Should [return Secp256k1KeyPair] if given [ECCurveType is Secp256k1]', () {
      // Arrange
      Uint8List actualSeedBytes = Uint8List.fromList(base64Decode('vOpcfoyicjfmT27GUbfAZpelsKZzF4RVQnbulaDkAcx9/De0WH3T0xJntB9Aywcs1AVvk5iCFHxOHfyNuATRJQ=='));

      // Act
      IBip32KeyPair actualBip32KeyPair = IBip32KeyPair.derive(
        derivationPath: DerivationPath.parse("m/44'/60'/0'/0/1"),
        seedBytes: actualSeedBytes,
        ecCurveType: ECCurveType.secp256k1,
      );

      // Assert
      IBip32KeyPair expectedBip32KeyPair = Secp256k1KeyPair(
        privateKey: Secp256k1PrivateKey(
          chainCodeBytes: base64Decode('znt9zxIhEIwNcbCgvHyKmnkn+Jj5NXDjhsV/sCx1IFM='),
          ecdsaPrivateKey: ECDSAPrivateKey(
            Curves.generatorSecp256k1,
            BigInt.parse('82879626032458563147801090670605979689983111889352406768424493826293886365473'),
          ),
        ),
        publicKey: Secp256k1PublicKey(
          ecdsaPublicKey: ECDSAPublicKey(
            Curves.generatorSecp256k1,
            ECPoint(
              x: BigInt.parse('112660828676629577966707117754281647176712908715660659892442173851290278739613'),
              y: BigInt.parse('16311829185915820381492804766921076197135792706285131420874486139658299278403'),
              z: BigInt.parse('27236590126955446289339796455648297156556079156841816312454810395243212447157'),
              n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
              curve: Curves.curveSecp256k1,
            ),
          ),
        ),
      );

      expect(actualBip32KeyPair, expectedBip32KeyPair);
    });
  });
}
