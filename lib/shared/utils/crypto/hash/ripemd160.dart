import 'dart:typed_data';

import 'package:pointycastle/digests/ripemd160.dart';

class Ripemd160 {
  Uint8List process(Uint8List data) {
    // TODO(dominik): Implement own version of RIPEMD16 hashing.
    return RIPEMD160Digest().process(data);
  }
}