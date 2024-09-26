import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';

class HexDisplayMode extends StatelessWidget {
  final Uint8List bytes;
  final TextStyle? textStyle;

  const HexDisplayMode({
    required this.bytes,
    required this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      HexCodec.encode(bytes, includePrefixBool: true),
      style: textStyle,
    );
  }
}
