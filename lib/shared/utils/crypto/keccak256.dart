import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/digests/keccak.dart';

final KeccakDigest keccakDigest = KeccakDigest(256);

class Keccak256 {
  static Uint8List encode(Uint8List input) {
    keccakDigest.reset();
    return keccakDigest.process(input);
  }

  static Uint8List encodeAscii(String input) {
    return encode(ascii.encode(input));
  }
}
