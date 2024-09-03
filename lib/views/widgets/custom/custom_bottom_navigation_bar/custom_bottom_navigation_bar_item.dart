import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_item_model.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  final bool selectedBool;
  final CustomBottomNavigationBarItemModel customBottomNavigationBarItemModel;
  final VoidCallback onTap;

  const CustomBottomNavigationBarItem({
    required this.selectedBool,
    required this.customBottomNavigationBarItemModel,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double size = customBottomNavigationBarItemModel.largeBool ? 46 : 34;

    return Expanded(
      child: Center(
        child: IconButton(
          onPressed: onTap,
          icon: SizedBox(
            width: size,
            height: size,
            child: AssetIcon(customBottomNavigationBarItemModel.assetIconData, color: selectedBool ? null : AppColors.darkGrey),
          ),
        ),
      ),
    );
  }
}
