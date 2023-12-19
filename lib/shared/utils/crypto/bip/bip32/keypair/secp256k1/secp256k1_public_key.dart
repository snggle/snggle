import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/extended_private_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_private_key.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/ecdsa_public_key.dart';

class Secp256k1PublicKey extends Equatable implements IBip32PublicKey {
  final ECDSAPublicKey ecdsaPublicKey;

  const Secp256k1PublicKey({required this.ecdsaPublicKey});

  factory Secp256k1PublicKey.fromExtendedPrivateKey(ExtendedPrivateKey extendedPrivateKey) {
    Secp256k1PrivateKey privateKey = Secp256k1PrivateKey.fromExtendedPrivateKey(extendedPrivateKey);
    return privateKey.publicKey;
  }

  @override
  Uint8List get compressed => ecdsaPublicKey.compressed;

  @override
  Uint8List get uncompressed => ecdsaPublicKey.uncompressed;

  @override
  List<Object?> get props => <Object>[ecdsaPublicKey];
}