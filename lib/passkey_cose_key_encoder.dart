import 'dart:typed_data';

import 'package:cryptography_utils/cryptography_utils.dart';

class PasskeyCoseKeyEncoder {
  static Map<int, dynamic> buildPublicKey(ECPublicKey publicKey) {
    Uint8List uncompressed = publicKey.uncompressed;

    Uint8List x = Uint8List.fromList(uncompressed.sublist(1, 33));
    Uint8List y = Uint8List.fromList(uncompressed.sublist(33, 65));

    return <int, dynamic>{
      1: 2,   // kty: EC2
      3: -7,  // alg: ES256
      -1: 1,  // crv: P-256
      -2: x,
      -3: y,
    };
  }
}
