import 'package:flutter/foundation.dart';

class BigIntUtils {
  static BigInt buildFromBytes(List<int> bytes) {
    List<int> updatedBytes = List<int>.from(bytes);
    BigInt result = BigInt.from(0);
    for (int i = 0; i < updatedBytes.length; i++) {
      result += BigInt.from(updatedBytes[updatedBytes.length - i - 1]) << (8 * i);
    }

    return result;
  }

  static Uint8List changeToBytes(BigInt value, {int? length}) {
    int byteLength = length ?? calculateByteLength(value);

    BigInt updatedValue = value;
    BigInt bigMaskEight = BigInt.from(0xff);
    if (updatedValue == BigInt.zero) {
      return Uint8List.fromList(List<int>.filled(byteLength, 0));
    }
    List<int> byteList = List<int>.filled(byteLength, 0);
    for (int i = 0; i < byteLength; i++) {
      byteList[byteLength - i - 1] = (updatedValue & bigMaskEight).toInt();
      updatedValue = updatedValue >> 8;
    }

    return Uint8List.fromList(byteList);
  }

  static int calculateByteLength(BigInt value) {
    String valueHex = value.toRadixString(16);
    int byteLength = (valueHex.length + 1) ~/ 2;
    return byteLength;
  }

  static List<BigInt> computeNAF(BigInt multiplier) {
    BigInt updatedMultiplier = multiplier;
    List<BigInt> nafList = <BigInt>[];

    while (updatedMultiplier != BigInt.zero) {
      if (updatedMultiplier.isOdd) {
        BigInt nafDigit = updatedMultiplier % BigInt.from(4);

        // Ensure that the NAF digit is within the range [-2, 2]
        if (nafDigit >= BigInt.two) {
          nafDigit -= BigInt.from(4);
        }

        nafList.add(nafDigit);
        updatedMultiplier -= nafDigit;
      } else {
        nafList.add(BigInt.zero);
      }

      updatedMultiplier ~/= BigInt.two;
    }

    return nafList;
  }
}
