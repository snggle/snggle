import 'dart:typed_data';

import 'package:snggle/shared/utils/crypto/address/i_blockchain_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/hash/ripemd160.dart';
import 'package:snggle/shared/utils/crypto/hash/sha256.dart';
import 'package:snggle/shared/utils/encoding/bech32/segwit_bech32_encoder.dart';

/// Pay-to-Witness-Public-Key-Hash (P2WPKH) address encoder.
class P2WPKHAddressEncoder implements IBlockchainAddressEncoder<Secp256k1PublicKey> {
  static const int _witnessVersion = 0;

  final String hrp;

  P2WPKHAddressEncoder({required this.hrp});

  @override
  String encodePublicKey(Secp256k1PublicKey publicKey) {
    Uint8List publicKeyFingerprint = Sha256().process(publicKey.compressed);
    Uint8List publicKeyHash = Ripemd160().process(publicKeyFingerprint);

    return SegwitBech32Encoder.encode(hrp, _witnessVersion, publicKeyHash);
  }
}
