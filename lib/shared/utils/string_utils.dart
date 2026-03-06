import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';

class StringUtils {
  static String getShortPublicAddress(String text, int length) {
    if (HexCodec.isHex(text)) {
      return '${text.substring(0, length + 2)}...${text.substring(text.length - length)}';
    } else {
      /// This condition is currently used for Solana addresses which are Base58-encoded strings, not HEX.
      /// It may be used for any String as well, such as Bitcoin addresses in the future.
      return '${text.substring(0, length)}...${text.substring(text.length - length)}';
    }
  }

  static Size getTextSize(String text, TextStyle style, {required TextScaler textScaler}) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr, textScaler: textScaler)
          ..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size;
  }
}
