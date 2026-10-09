import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography_utils/cryptography_utils.dart';

class PasskeyAuthenticatorDataBuilder {
  static Uint8List build({
    required String rpId,
    required Uint8List credentialId,
    required Uint8List cosePublicKey,
  }) {
    if (credentialId.length > 65535) {
      throw ArgumentError('Credential ID is too long');
    }

    Digest digest = Sha256().convert(utf8.encode(rpId));
    Uint8List rpIdHash = Uint8List.fromList(digest.byteList);

    BytesBuilder builder = BytesBuilder()

    ..add(rpIdHash)
    ..addByte(0x41) // UP + AT
    ..add(Uint8List(4)) // signCount
    ..add(Uint8List(16)); // AAGUID

    ByteData credentialIdLength = ByteData(2)
    ..setUint16(0, credentialId.length, Endian.big);

    builder..add(credentialIdLength.buffer.asUint8List())
    ..add(credentialId)
    ..add(cosePublicKey);

    return builder.toBytes();
  }
}