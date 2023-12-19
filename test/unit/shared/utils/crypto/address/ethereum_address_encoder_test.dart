import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/address/ethereum_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

void main() {
  ECPoint actualPointQ = ECPoint(
    x: BigInt.parse('49844093485842753019501723164709087800134847594852664670182601545797061237061'),
    y: BigInt.parse('102584019795063234624860865414832132871049165551248963828805190591824528686504'),
    z: BigInt.parse('33112508886275853310422687256511308836721055527980470378416551104097868981749'),
    n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
    curve: Curves.curveSecp256k1,
  );

  Secp256k1PublicKey actualPublicKey = Secp256k1PublicKey(ecdsaPublicKey: ECDSAPublicKey(Curves.generatorSecp256k1, actualPointQ));

  group('Tests of EthereumAddressEncoder.encodePublicKey()', () {
    test('Should [return Etherum address] [WITH checksum] for given public key', () {
      // Arrange
      EthereumAddressEncoder actualEthereumAddressEncoder = EthereumAddressEncoder(skipChecksumBool: false);

      // Act
      String actualAddress = actualEthereumAddressEncoder.encodePublicKey(actualPublicKey);

      // Assert
      String expectedAddress = '0x50e10257924889818aA729c6EDfa02524b32Edb9';

      expect(actualAddress, expectedAddress);
    });

    test('Should [return Etherum address] [WITHOUT checksum] for given public key', () {
      // Arrange
      EthereumAddressEncoder actualEthereumAddressEncoder = EthereumAddressEncoder(skipChecksumBool: true);

      // Act
      String actualAddress = actualEthereumAddressEncoder.encodePublicKey(actualPublicKey);

      // Assert
      String expectedAddress = '50e10257924889818aa729c6edfa02524b32edb9';

      expect(actualAddress, expectedAddress);
    });
  });
}
