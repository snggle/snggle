import 'dart:convert';

import 'package:crypto/crypto.dart';

class Sha256 {
  static Digest encrypt(String content) {
    List<int> bytes = utf8.encode(content);
    Digest digest = sha256.convert(bytes);
    return digest;
  }
}
