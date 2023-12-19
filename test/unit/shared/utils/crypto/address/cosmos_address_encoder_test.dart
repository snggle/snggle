import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/address/cosmos_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

void main() {
  ECPoint actualPointQ = ECPoint(
    x: BigInt.parse('103541830980023606809613093633067363502594290705821036222890728111110906420509'),
    y: BigInt.parse('75808906644622006047938879719654783679105512040910575915102508326553703647166'),
    z: BigInt.parse('3190226348536498292494465017020441737630476122313049345633869118655223224149'),
    n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
    curve: Curves.curveSecp256k1,
  );

  Secp256k1PublicKey actualPublicKey = Secp256k1PublicKey(ecdsaPublicKey: ECDSAPublicKey(Curves.generatorSecp256k1, actualPointQ));

  group('Tests of CosmosAddressEncoder.encodePublicKey()', () {
    test('Should [return Cosmos address] for given public key (cosmos)', () {
      // Arrange
      CosmosAddressEncoder actualCosmosAddressEncoder = CosmosAddressEncoder(hrp: 'cosmos');

      // Act
      String actualAddress = actualCosmosAddressEncoder.encodePublicKey(actualPublicKey);

      // Assert
      String expectedAddress = 'cosmos143q8vxpvuykt9pq50e6hng9s38vmy844rgut0t';

      expect(actualAddress, expectedAddress);
    });

    test('Should [return Cosmos address] for given public key (kira)', () {
      // Arrange
      CosmosAddressEncoder actualCosmosAddressEncoder = CosmosAddressEncoder(hrp: 'kira');

      // Act
      String actualAddress = actualCosmosAddressEncoder.encodePublicKey(actualPublicKey);

      // Assert
      String expectedAddress = 'kira143q8vxpvuykt9pq50e6hng9s38vmy844n8k9wx';

      expect(actualAddress, expectedAddress);
    });
  });
}
