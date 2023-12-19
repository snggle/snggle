import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/extended_private_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_private_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_private_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';

class Secp256k1PrivateKey extends Equatable implements IBip32PrivateKey {
  final ECDSAPrivateKey ecdsaPrivateKey;
  final Uint8List _chainCodeBytes;

  const Secp256k1PrivateKey({
    required this.ecdsaPrivateKey,
    required Uint8List chainCodeBytes,
  }) : _chainCodeBytes = chainCodeBytes;

  factory Secp256k1PrivateKey.fromExtendedPrivateKey(ExtendedPrivateKey extendedPrivateKey) {
    ECDSAPrivateKey ecdsaPrivateKey = ECDSAPrivateKey.fromBytes(extendedPrivateKey.privateKeyBytes, Curves.generatorSecp256k1);
    return Secp256k1PrivateKey(ecdsaPrivateKey: ecdsaPrivateKey, chainCodeBytes: extendedPrivateKey.chainCodeBytes);
  }

  Secp256k1PublicKey get publicKey {
    ECDSAPublicKey ecdsaPublicKey = ECDSAPublicKey(ecdsaPrivateKey.G, ecdsaPrivateKey.G * ecdsaPrivateKey.d);
    return Secp256k1PublicKey(ecdsaPublicKey: ecdsaPublicKey);
  }

  @override
  Uint8List get chainCodeBytes => _chainCodeBytes;

  @override
  Uint8List get bytes => ecdsaPrivateKey.bytes;

  @override
  int get length => ecdsaPrivateKey.length;

  @override
  List<Object?> get props => <Object>[ecdsaPrivateKey, _chainCodeBytes];
}