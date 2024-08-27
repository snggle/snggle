import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';

class StringUtils {
  static String getShortHex(String hex, int length) {
    if (HexCodec.isHex(hex)) {
      return '${hex.substring(0, length + 2)}...${hex.substring(hex.length - length)}';
    } else {
      return hex;
    }
  }

  static Size getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
