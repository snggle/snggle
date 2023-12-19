import 'dart:typed_data';

import 'package:pointycastle/export.dart';

class Hmac {
  Uint8List process(Uint8List key, Uint8List data) {
    // TODO(dominik): implement own hmac hashing algorithm
    HMac tmp = HMac.withDigest(SHA512Digest())..init(KeyParameter(key));
    return tmp.process(data);
  }
}
