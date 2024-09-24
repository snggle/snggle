import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snggle/config/app_icons/app_icons.dart';

class AssetIcon extends StatelessWidget {
  final AssetIconData assetIconData;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;

  const AssetIcon(
    this.assetIconData, {
    this.size = 24,
    this.width,
    this.height,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? size,
      height: height ?? size,
      child: SvgPicture.asset(
        assetIconData.assetName,
        width: width ?? size,
        height: height ?? size,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }
}
