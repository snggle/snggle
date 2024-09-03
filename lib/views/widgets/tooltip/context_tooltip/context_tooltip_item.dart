import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class ContextTooltipItem extends StatelessWidget {
  final AssetIconData assetIconData;
  final String label;
  final VoidCallback? onTap;

  const ContextTooltipItem({
    required this.assetIconData,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget = TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AssetIcon(assetIconData, size: 16, color: AppColors.body3),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.body3, height: 1, letterSpacing: 0),
          ),
        ],
      ),
    );

    if (onTap == null) {
      buttonWidget = Opacity(
        opacity: 0.5,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
