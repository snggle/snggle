import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/utils/crypto/address/p2sh_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';

void main() {
  ECPoint actualPointQ = ECPoint(
    x: BigInt.parse('45598833024007063412331531275003851810927383922680420932075021036000176892257'),
    y: BigInt.parse('52075805451846365275495005964097842681620553159632658097877797800509943385562'),
    z: BigInt.parse('11902898874332229604673834019199903475888972972060602920606280067238874780442'),
    n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
    curve: Curves.curveSecp256k1,
  );

  Secp256k1PublicKey actualPublicKey = Secp256k1PublicKey(ecdsaPublicKey: ECDSAPublicKey(Curves.generatorSecp256k1, actualPointQ));

  group('Tests of P2SHAddressEncoder.encodePublicKey()', () {
    test('Should [return P2SH address] for given public key', () {
      // Arrange
      P2SHAddressEncoder actualP2SHAddressEncoder = P2SHAddressEncoder();

      // Act
      String actualAddress = actualP2SHAddressEncoder.encodePublicKey(actualPublicKey);

      // Assert
      String expectedAddress = '38BaaMYeUR32tptWPcfLiuZwdkq1iHy7mW';

      expect(actualAddress, expectedAddress);
    });
  });
}
