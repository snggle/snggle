import 'dart:typed_data';

import 'package:pointycastle/digests/sha256.dart';
import 'package:snggle/shared/utils/big_int_utils.dart';

class Base58 {
  /// The radix for Base58 encoding.
  static const int _radix = 58;
  
  /// The length (in bytes) of the checksum used in Base58 encoding.
  static const int _checksumByteLen = 4;
  
  static const String _bitcoinAlphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  static String encodeWithChecksum(Uint8List dataBytes) {
    List<int> checksum = _computeChecksum(dataBytes);
    List<int> dataWithChecksum = List<int>.from(<int>[...dataBytes, ...checksum]);
    return encode(Uint8List.fromList(dataWithChecksum));
  }
  
  static String encode(Uint8List dataBytes) {
    String alphabet = _bitcoinAlphabet;

    BigInt value = BigIntUtils.buildFromBytes(dataBytes);
    String enc = '';
    while (value > BigInt.zero) {
      BigInt dividedValue = value ~/ BigInt.from(_radix);
      BigInt modulatedValue = value % BigInt.from(_radix);

      value = dividedValue;
      enc = alphabet[modulatedValue.toInt()] + enc;
    }

    int zero = 0;
    for (int byte in dataBytes) {
      if (byte == 0) {
        zero++;
      } else {
        break;
      }
    }
    final int leadingZeros = dataBytes.length - (dataBytes.length - zero);

    return (alphabet[0] * leadingZeros) + enc;
  }

  static List<int> _computeChecksum(Uint8List dataBytes) {
    Uint8List doubleSha256Digest = SHA256Digest().process(SHA256Digest().process(dataBytes));
    return doubleSha256Digest.sublist(0, _checksumByteLen);
  }
}