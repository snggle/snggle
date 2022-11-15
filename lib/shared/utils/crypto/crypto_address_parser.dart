import 'dart:typed_data';

import 'package:hex/hex.dart';
// ignore: implementation_imports
import 'package:pointycastle/src/utils.dart' as p_utils;

class CryptoAddressParser {
  static final BigInt _byteMask = BigInt.from(0xff);

  /// Converts the [bytes] given as a list of integers into a hexadecimal
  /// representation.
  ///
  /// If any of the bytes is outside of the range [0, 256], the method will throw.
  /// The outcome of this function will prefix a 0 if it would otherwise not be
  /// of even length. If [include0x] is set, it will prefix "0x" to the hexadecimal
  /// representation. If [forcePadLength] is set, the hexadecimal representation
  /// will be expanded with zeroes until the desired length is reached. The "0x"
  /// prefix does not count for the length.
  static String bytesToHex(
    List<int> bytes, {
    int? forcePadLength,
    bool padToEvenLength = false,
  }) {
    String hexAddress = HEX.encode(bytes);

    if (forcePadLength != null) {
      assert(forcePadLength >= hexAddress.length, '');

      final int padding = forcePadLength - hexAddress.length;
      hexAddress = ('0' * padding) + hexAddress;
    }

    if (padToEvenLength && hexAddress.length % 2 != 0) {
      hexAddress = '0$hexAddress';
    }

    return '0x$hexAddress';
  }

  /// Converts the hexadecimal string, which can be prefixed with 0x, to a byte
  /// sequence.
  static Uint8List hexToBytes(String hexStr) {
    final List<int> bytes = HEX.decode(stripHexPrefix(hexStr));
    if (bytes is Uint8List) {
      return bytes;
    }

    return Uint8List.fromList(bytes);
  }

  /// If present, removes the 0x from the start of a hex-string.
  static String stripHexPrefix(String hex) {
    if (hex.startsWith('0x')) {
      return hex.substring(2);
    }
    return hex;
  }

  static Uint8List unsignedIntToBytes(BigInt number) {
    assert(!number.isNegative, '');
    return p_utils.encodeBigIntAsUnsigned(number);
  }

  static BigInt bytesToUnsignedInt(Uint8List bytes) {
    return p_utils.decodeBigIntWithSign(1, bytes);
  }

  /// Converts the bytes from that list (big endian) to a (potentially signed)
  /// BigInt.
  static BigInt bytesToInt(List<int> bytes) {
    BigInt result = BigInt.from(0);
    for (int i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  static Uint8List intToBytes(BigInt number) {
    final int size = (number.bitLength + 7) >> 3;
    final Uint8List result = Uint8List(size);
    BigInt num = number;
    for (int i = 0; i < size; i++) {
      result[size - i - 1] = (num & _byteMask).toInt();
      num = num >> 8;
    }
    return result;
  }
}
