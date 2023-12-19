import 'dart:typed_data';

import 'package:snggle/shared/utils/crypto/address/i_blockchain_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_public_key.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/hash/ripemd160.dart';
import 'package:snggle/shared/utils/crypto/hash/sha256.dart';
import 'package:snggle/shared/utils/encoding/base/base58.dart';

///  Pay-toScriptHash (P2SH) address encoder.
class P2SHAddressEncoder implements IBlockchainAddressEncoder<Secp256k1PublicKey> {
  static const List<int> _networkVersionBytes = <int>[0x05];
  static const List<int> _scriptBytes = <int>[0x00, 0x14];

  P2SHAddressEncoder();

  @override
  String encodePublicKey(Secp256k1PublicKey publicKey) {
    /// Generate the script signature from the public key.
    List<int> scriptSignatureBytes = _addScriptSignature(publicKey);

    return Base58.encodeWithChecksum(Uint8List.fromList(<int>[..._networkVersionBytes, ...scriptSignatureBytes]));
  }

  List<int> _addScriptSignature(IBip32PublicKey publicKey) {
    Uint8List publicKeyFingerprint = Sha256().process(publicKey.compressed);
    Uint8List publicKeyHash = Ripemd160().process(publicKeyFingerprint);

    Uint8List signatureBytes = Uint8List.fromList(<int>[..._scriptBytes, ...publicKeyHash]);
    Uint8List signatureFingerprint = Sha256().process(signatureBytes);
    Uint8List signatureHash = Ripemd160().process(signatureFingerprint);

    return signatureHash;
  }
}
