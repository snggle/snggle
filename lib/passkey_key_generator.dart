import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography_utils/cryptography_utils.dart';

class PasskeyKeyGenerator {
  static ECPrivateKey generatePrivateKey() {
    ECPoint generator = CurvePoints.generatorSecp256r1;
    BigInt n = generator.n;

    Random random = Random.secure();
    Uint8List bytes = Uint8List(32);

    while (true) {
      for (int i = 0; i < bytes.length; i++) {
        bytes[i] = random.nextInt(256);
      }

      BigInt d = BigInt.parse(
        bytes.map((int byte) => byte.toRadixString(16).padLeft(2, '0')).join(),
        radix: 16,
      );

      if (d > BigInt.zero && d < n) {
        return ECPrivateKey(generator, d);
      }
    }
  }
}
