import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:snggle/shared/utils/big_int_utils.dart';

class AbiUtils {
  static const int abiChunkSize = 32;

  static String? parseChunkToString(Uint8List chunkBytes) {
    List<int> textBytes = chunkBytes.toList();
    while (textBytes.isNotEmpty && textBytes.last == 0) {
      textBytes.removeLast();
    }

    if (textBytes.length < 3) {
      return null;
    }

    try {
      String result = String.fromCharCodes(textBytes);
      if (result.runes.every((int rune) => rune >= 32 && rune <= 126)) {
        return result;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static String? parseChunkToAddress(Uint8List chunkBytes) {
    List<int> trimmedBytes = List<int>.from(chunkBytes);
    while (trimmedBytes.length > 20 && trimmedBytes[0] == 0) {
      trimmedBytes.removeAt(0);
    }

    if (trimmedBytes.length == 20) {
      return HexCodec.encode(trimmedBytes, includePrefixBool: true);
    } else {
      return null;
    }
  }

  static String parseChunkToNumber(Uint8List chunkBytes) {
    return BigIntUtils.decode(chunkBytes).toString();
  }
}
