import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';

class AssetAnimatedIcon extends StatelessWidget {
  final AssetAnimatedIconData assetAnimatedIconData;
  final Color? color;
  final double? size;
  final double? height;
  final double? width;

  const AssetAnimatedIcon(
    this.assetAnimatedIconData, {
    this.color,
    this.height,
    this.width,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? width,
      height: size ?? height,
      child: Center(child: Image.asset(assetAnimatedIconData.assetName, fit: BoxFit.fitHeight)),
    );
  }
}
