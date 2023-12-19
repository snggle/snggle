import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/address/p2wpkh_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

void main() {
  ECPoint actualPointQ = ECPoint(
    x: BigInt.parse('76703126420722322007634345723463650715654444727861292197619275780698078484198'),
    y: BigInt.parse('74654274679389979607131077993714677055519561275235266585538223878569670773020'),
    z: BigInt.parse('40734431342056095760694605795848451157672234281365399275614292579983211792826'),
    n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
    curve: Curves.curveSecp256k1,
  );

  Secp256k1PublicKey actualPublicKey = Secp256k1PublicKey(ecdsaPublicKey: ECDSAPublicKey(Curves.generatorSecp256k1, actualPointQ));

  group('Tests of P2WPKHAddressEncoder.encodePublicKey()', () {
    test('Should [return P2WPKH address] for given public key', () {
      // Arrange
      P2WPKHAddressEncoder actualP2PKHAddressEncoder = P2WPKHAddressEncoder(hrp: 'bc');

      // Act
      String actualAddress = actualP2PKHAddressEncoder.encodePublicKey(actualPublicKey);

      // Assert
      String expectedAddress = 'bc1quxjugvagpv4kz5hdkh7x0qklarw5akdk2sg0wp';

      expect(actualAddress, expectedAddress);
    });
  });
}
