import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';



class Curves {
  static ECPoint get generatorSecp256k1 => ECPoint(
        x: BigInt.parse('79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798', radix: 16),
        y: BigInt.parse('483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8', radix: 16),
        z: BigInt.one,
        n: BigInt.parse('115792089237316195423570985008687907852837564279074904382605163141518161494337'),
        curve: curveSecp256k1,
      );

  static ECCurve get curveSecp256k1 => ECCurve(
        b: BigInt.from(7),
        a: BigInt.zero,
        h: BigInt.one,
        p: BigInt.parse('115792089237316195423570985008687907853269984665640564039457584007908834671663'),
      );
}
