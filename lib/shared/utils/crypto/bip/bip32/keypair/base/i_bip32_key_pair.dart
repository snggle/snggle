import 'dart:typed_data';

import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_private_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_key_pair.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/curves/ec_curve_type.dart';

abstract interface class IBip32KeyPair {
  IBip32PrivateKey get privateKey;

  IBip32PublicKey get publicKey;

  static IBip32KeyPair derive({
    required DerivationPath derivationPath,
    required Uint8List seedBytes,
    required ECCurveType ecCurveType,
  }) {
    switch (ecCurveType) {
      case ECCurveType.secp256k1:
        return Secp256k1KeyPair.derive(seedBytes, derivationPath);
      default:
        throw Exception('Unsupported elliptic curve type');
    }
  }
}
