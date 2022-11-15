import 'dart:typed_data';

import 'package:pointycastle/digests/ripemd160.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:snuggle/shared/utils/crypto/crypto_address_parser.dart';

class Secp256k1 {
  /// Generates a public key for the given private key using the ecdsa curve which
  /// Ethereum uses.
  static Uint8List privateKeyBytesToPublic(Uint8List privateKey) {
    BigInt actualInt = CryptoAddressParser.bytesToUnsignedInt(privateKey);
    return privateKeyToPublic(actualInt);
  }

  /// Generates a public key for the given private key using the ecdsa curve which
  /// Ethereum uses.
  static Uint8List privateKeyToPublic(BigInt privateKey) {
    // Get the curve data
    final ECCurve_secp256k1 secp256k1 = ECCurve_secp256k1();
    final ECPoint point = secp256k1.G;

    // Compute the curve point associated to the private key
    final ECPoint? curvePoint = point * privateKey;

    // Get the public key
    final Uint8List publicKeyBytes = curvePoint!.getEncoded();
    return publicKeyBytes;
  }

  static Uint8List publicKeyToAddress(Uint8List publicKey) {
    final Uint8List sha256Digest = SHA256Digest().process(publicKey);
    final Uint8List address = RIPEMD160Digest().process(sha256Digest);
    return address;
  }
}
