import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  final bool selectedBool;
  final AssetIconData assetIconData;
  final VoidCallback onTap;

  const CustomBottomNavigationBarItem({
    required this.selectedBool,
    required this.assetIconData,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: AssetIcon(assetIconData, color: selectedBool ? null : AppColors.darkGrey, size: 34),
    );
  }
}
