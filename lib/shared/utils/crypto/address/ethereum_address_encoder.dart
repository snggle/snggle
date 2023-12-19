import 'dart:convert';
import 'dart:typed_data';

import 'package:snggle/shared/utils/crypto/address/i_blockchain_address_encoder.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/secp256k1/secp256k1_public_key.dart';
import 'package:snggle/shared/utils/crypto/hash/keccak.dart';
import 'package:snggle/shared/utils/encoding/hex/hex.dart';

class EthereumAddressEncoder implements IBlockchainAddressEncoder<Secp256k1PublicKey> {
  static const int _startByte = 24;

  final bool skipChecksumBool;

  EthereumAddressEncoder({
    this.skipChecksumBool = false,
  });

  @override
  String encodePublicKey(Secp256k1PublicKey publicKey) {
    Uint8List keccakHash = Keccak(256).process(publicKey.uncompressed.sublist(1));
    String keccakHex = Hex().encode(keccakHash, lowercaseBool: true);

    String address = keccakHex.substring(_startByte);
    if (skipChecksumBool) {
      return address;
    }
    return '0x${_wrapWithChecksum(address)}';

  }

  static String _wrapWithChecksum(String address) {
    Uint8List addressBytes = utf8.encode(address.toLowerCase());
    Uint8List checksumBytes = Keccak(256).process(addressBytes);
    String checksumHex = Hex().encode(checksumBytes, lowercaseBool: true);
    
    List<String> addressWithChecksum = address.split('').asMap().entries.map((MapEntry<int, String> entry) {
      int index = entry.key;
      String char = entry.value;
      int charChecksumHex = int.parse(checksumHex[index], radix: 16);
      return charChecksumHex >= 8 ? char.toUpperCase() : char.toLowerCase();
    }).toList();

    return addressWithChecksum.join();
  }
}
