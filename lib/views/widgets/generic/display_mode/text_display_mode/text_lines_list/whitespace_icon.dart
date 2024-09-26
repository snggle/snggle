import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class WhitespaceIcon {
  final AssetIconData assetIconData;
  final double? size;
  final double? width;
  final double? height;

  const WhitespaceIcon(
    this.assetIconData, {
    this.size = 24,
    this.width,
    this.height,
  });

  WidgetSpan getWidgetSpan() {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AssetIcon(assetIconData, width: width, height: height, size: size),
      ),
    );
  }
}
