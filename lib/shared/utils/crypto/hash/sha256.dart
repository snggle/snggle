import 'dart:typed_data';

import 'package:pointycastle/digests/sha256.dart';

class Sha256 {
  Uint8List process(Uint8List data) {
    // TODO(dominik): Implement own version of SHA256 hashing.
    return SHA256Digest().process(data);
  }
}