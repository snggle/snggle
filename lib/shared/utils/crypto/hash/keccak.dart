import 'dart:typed_data';

import 'package:pointycastle/digests/keccak.dart';

class Keccak {
  final int digestSize;

  Keccak(this.digestSize);

  Uint8List process(Uint8List data) {
    // TODO(dominik): Implement own version of Keccak hashing.
    return KeccakDigest(digestSize).process(data);
  }
}