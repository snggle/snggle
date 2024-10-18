import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class Fingerprinter {
  static String createFingerprint(Uint8List data) {
    return base64Encode(sha256.convert(data).bytes);
  }
}
