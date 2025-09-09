import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';

class StringUtils {
  static String getShortText(String text, int length) {
    if (HexCodec.isHex(text)) {
      return '${text.substring(0, length + 2)}...${text.substring(text.length - length)}';
    } else {
      return '${text.substring(0, length)}...${text.substring(text.length - length)}';
    }
  }

  static Size getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
