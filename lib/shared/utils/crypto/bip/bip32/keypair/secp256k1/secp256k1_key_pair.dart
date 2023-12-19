import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path_element.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/extended_private_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_key_pair.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_private_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32_hmac_keys.dart';
import 'package:snggle/shared/utils/crypto/bip/curves.dart';

class Secp256k1KeyPair extends Equatable implements IBip32KeyPair {
  final Secp256k1PrivateKey _privateKey;
  final Secp256k1PublicKey _publicKey;

  const Secp256k1KeyPair({
    required Secp256k1PrivateKey privateKey,
    required Secp256k1PublicKey publicKey,
  }) : _privateKey = privateKey,
       _publicKey = publicKey;

  factory Secp256k1KeyPair.fromPrivateKey(Secp256k1PrivateKey privateKey) {
    Secp256k1PublicKey publicKey = privateKey.publicKey;
    return Secp256k1KeyPair(privateKey: privateKey, publicKey: publicKey);
  }

  factory Secp256k1KeyPair.fromSeed(Uint8List seedBytes) {
    ExtendedPrivateKey extendedPrivateKey = ExtendedPrivateKey.fromSeed(
      seedBytes,
      List<int>.from(Bip32HMACKeys.hmacKeySecp256k1Bytes),
    );

    Secp256k1PrivateKey privateKey = Secp256k1PrivateKey.fromExtendedPrivateKey(extendedPrivateKey);
    Secp256k1PublicKey publicKey = privateKey.publicKey;
    return Secp256k1KeyPair(privateKey: privateKey, publicKey: publicKey);
  }

  factory Secp256k1KeyPair.derive(Uint8List seedBytes, DerivationPath derivationPath) {
    Secp256k1KeyPair masterKeyPair = Secp256k1KeyPair.fromSeed(seedBytes);
    Secp256k1KeyPair derivedKeyPair = masterKeyPair;

    for (DerivationPathElement derivationPathElement in derivationPath.elements) {
      derivedKeyPair = derivedKeyPair.buildChildKeyPair(derivationPathElement);
    }
    return derivedKeyPair;
  }

  @override
  Secp256k1PrivateKey get privateKey => _privateKey;

  @override
  Secp256k1PublicKey get publicKey => _publicKey;

  Secp256k1KeyPair buildChildKeyPair(DerivationPathElement pathElement) {
    ExtendedPrivateKey derivedExtendedPrivateKey = ExtendedPrivateKey.deriveChildKey(this, pathElement, Curves.generatorSecp256k1);

    Secp256k1PrivateKey privateKey = Secp256k1PrivateKey.fromExtendedPrivateKey(derivedExtendedPrivateKey);
    Secp256k1PublicKey publicKey = privateKey.publicKey;

    return Secp256k1KeyPair(
      privateKey: privateKey,
      publicKey: publicKey,
    );
  }

  @override
  List<Object?> get props => <Object>[_privateKey, _publicKey];
}
