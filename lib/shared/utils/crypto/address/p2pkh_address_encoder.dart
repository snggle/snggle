import 'dart:typed_data';

import 'package:snggle/shared/utils/crypto/address/i_blockchain_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/hash/ripemd160.dart';
import 'package:snggle/shared/utils/crypto/hash/sha256.dart';
import 'package:snggle/shared/utils/crypto/public_key_mode.dart';
import 'package:snggle/shared/utils/encoding/base/base58.dart';

/// Pay-to-Public-Key-Hash (P2PKH) address encoder.
class P2PKHAddressEncoder implements IBlockchainAddressEncoder<Secp256k1PublicKey> {
  static const List<int> _networkVersionBytes = <int>[0x00];
  final PublicKeyMode publicKeyMode;

  P2PKHAddressEncoder({
    this.publicKeyMode = PublicKeyMode.compressed,
  });

  @override
  String encodePublicKey(Secp256k1PublicKey publicKey) {
    Uint8List publicKeyBytes = publicKeyMode == PublicKeyMode.compressed ? publicKey.compressed : publicKey.uncompressed;

    Uint8List publicKeyFingerprint = Sha256().process(publicKeyBytes);
    Uint8List publicKeyHash = Ripemd160().process(publicKeyFingerprint);

    return Base58.encodeWithChecksum(Uint8List.fromList(<int>[..._networkVersionBytes, ...publicKeyHash]));
  }
}
