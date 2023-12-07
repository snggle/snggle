import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar_item_model.dart';

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
    Widget icon = SvgPicture.asset(
      customBottomNavigationBarItemModel.iconPath,
      fit: BoxFit.fitHeight,
      theme: SvgTheme(currentColor: AppColors.darkGrey),
    );

    if (selectedBool) {
      icon = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          return AppColors.primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          );
        },
        child: icon,
      );
    }

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 64,
          padding: customBottomNavigationBarItemModel.largeBool ? const EdgeInsets.all(9) : const EdgeInsets.all(15),
          child: icon,
        ),
      ),
    );
  }
}
