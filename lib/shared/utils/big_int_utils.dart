import 'dart:typed_data';

class BigIntUtils {
  static BigInt decode(List<int> bytes, {int? bitLength, Endian order = Endian.big}) {
    List<int> tmpBytes = bytes;
    if (order == Endian.little) {
      tmpBytes = List<int>.from(bytes.reversed.toList());
    }

    int bytesBitLength = tmpBytes.length * 8;

    BigInt result = BigInt.zero;
    for (int i = 0; i < tmpBytes.length; i++) {
      result += BigInt.from(tmpBytes[tmpBytes.length - i - 1]) << (8 * i);
    }

    if (bitLength != null && bytesBitLength >= bitLength) {
      result >>= bytesBitLength - bitLength;
    }
    return result;
  }
}
