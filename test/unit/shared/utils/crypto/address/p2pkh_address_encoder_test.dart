import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/address/p2pkh_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';
import 'package:snggle/shared/utils/crypto/public_key_mode.dart';

void main() {
  ECPoint actualPointQ = ECPoint(
    x: BigInt.parse('38336877429777144060267786813855742566762755003810222330370030177500553175552'),
    y: BigInt.parse('43563831752869961512099662435070760564842488811079803779798870455459619618648'),
    z: BigInt.parse('84221606303351351252384011276733806130312533127115701665238461934963837834470'),
    n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
    curve: Curves.curveSecp256k1,
  );

  Secp256k1PublicKey actualPublicKey = Secp256k1PublicKey(ecdsaPublicKey: ECDSAPublicKey(Curves.generatorSecp256k1, actualPointQ));

  group('Tests of P2PKHAddressEncoder.encodePublicKey()', () {
    test('Should [return P2PKH address] for given public key (public key COMPRESSED)', () {
      // Arrange
      P2PKHAddressEncoder actualP2PKHAddressEncoder = P2PKHAddressEncoder(publicKeyMode: PublicKeyMode.compressed);

      // Act
      String actualAddress = actualP2PKHAddressEncoder.encodePublicKey(actualPublicKey);

      // Assert
      String expectedAddress = '12CUuS1w48dmLqug3sQeZGXhM6ziyLdDFR';

      expect(actualAddress, expectedAddress);
    });

    test('Should [return P2PKH address] for given public key (public key UNCOMPRESSED)', () {
      // Arrange
      P2PKHAddressEncoder actualP2PKHAddressEncoder = P2PKHAddressEncoder(publicKeyMode: PublicKeyMode.uncompressed);

      // Act
      String actualAddress = actualP2PKHAddressEncoder.encodePublicKey(actualPublicKey);

      // Assert
      String expectedAddress = '1PkHDRGVzHNc3dSnBEZ8MzULiyTKEibk7c';

      expect(actualAddress, expectedAddress);
    });
  });
}
