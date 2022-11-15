import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snuggle/shared/utils/crypto/bech32.dart';
import 'package:snuggle/shared/utils/crypto/crypto_address_parser.dart';
import 'package:snuggle/shared/utils/crypto/keccak256.dart';
import 'package:snuggle/shared/utils/crypto/secp256k1.dart';

/// Represents an wallet address.
/// Source: https://github.com/LmFlutterSDK/web3dart/blob/master/lib/src/credentials/address.dart
class AddressModel extends Equatable {
  static final RegExp _basicAddress = RegExp('^(0x)?[0-9a-f]{40}', caseSensitive: false);

  /// The length of an ethereum address, in bytes.
  static const int addressByteLength = 20;

  final Uint8List addressBytes;

  final String bech32Hrp;

  /// An ethereum address from the raw address bytes.
  const AddressModel({
    required this.addressBytes,
    required this.bech32Hrp,
  }) : assert(addressBytes.length == addressByteLength, 'Address should be $addressByteLength bytes length');

  /// Constructs an Ethereum address from a public key. The address is formed by
  /// the last 20 bytes of the keccak hash of the public key.
  factory AddressModel.fromPublicKey(Uint8List publicKey, {required String bech32Hrp}) {
    return AddressModel(addressBytes: Secp256k1.publicKeyToAddress(publicKey), bech32Hrp: bech32Hrp);
  }

  factory AddressModel.fromBech32(String bech32Address) {
    final Bech32Pair bech32pair = Bech32.decode(bech32Address);
    return AddressModel(addressBytes: bech32pair.data, bech32Hrp: bech32pair.hrp);
  }

  /// Parses an Ethereum address from the hexadecimal representation. The
  /// representation must have a length of 20 bytes (or 40 hexadecimal chars),
  /// and can optionally be prefixed with "0x".
  ///
  /// If [enforceEip55] is true or the address has both uppercase and lowercase
  /// chars, the address must be valid according to [EIP 55](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md).
  // TODO(dominik): Currently unused. Remove before release
  factory AddressModel.fromHex(String hex, {required String bech32Hrp, bool enforceEip55 = false}) {
    if (!_basicAddress.hasMatch(hex)) {
      throw ArgumentError.value(hex, 'address', 'Must be a hex string with a length of 40, optionally prefixed with "0x"');
    }

    if (!enforceEip55 && (hex.toUpperCase() == hex || hex.toLowerCase() == hex)) {
      return AddressModel(addressBytes: CryptoAddressParser.hexToBytes(hex), bech32Hrp: bech32Hrp);
    }

    // Validates as of EIP 55, https://ethereum.stackexchange.com/a/1379
    final String address = CryptoAddressParser.stripHexPrefix(hex);
    final String hash = CryptoAddressParser.bytesToHex(Keccak256.encodeAscii(address.toLowerCase()));
    for (int i = 0; i < 40; i++) {
      // the nth letter should be uppercase if the nth digit of casemap is 1
      final int hashedPos = int.parse(hash[i], radix: 16);
      if ((hashedPos > 7 && address[i].toUpperCase() != address[i]) || (hashedPos <= 7 && address[i].toLowerCase() != address[i])) {
        throw ArgumentError('Address has invalid case-characters and is thus not EIP-55 conformant, rejecting. Address was: $hex');
      }
    }

    return AddressModel(addressBytes: CryptoAddressParser.hexToBytes(hex), bech32Hrp: bech32Hrp);
  }

  /// A hexadecimal representation of this address, padded to a length of 40
  /// characters or 20 bytes, but not prefixed with "0x".
  // TODO(dominik): Currently unused. Remove before release
  String get hexWithoutPrefix {
    return CryptoAddressParser.stripHexPrefix(hex);
  }

  /// A hexadecimal representation of this address, padded to a length of 40
  /// characters or 20 bytes, and prefixed with "0x".
  // TODO(dominik): Currently unused. Remove before release
  String get hex => CryptoAddressParser.bytesToHex(addressBytes, forcePadLength: 40);

  /// Returns the associated [address] as a Bech32 string.
  String get bech32Address => Bech32.encode(bech32Hrp, addressBytes);

  /// Returns the associated [address] as a Bech32 string.
  String get bech32Shortcut {
    String address = bech32Address;
    String firstPart = address.substring(0, 8);
    String lastPart = address.substring(address.length - 4, address.length);
    return '${firstPart}_$lastPart';
  }

  @override
  List<Object?> get props => <Object>[hex];

  @override
  String toString() => hex;
}
