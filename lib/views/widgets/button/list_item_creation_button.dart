import 'package:flutter/cupertino.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class ListItemCreationButton extends StatelessWidget {
  final Size size;
  final VoidCallback onTap;

  const ListItemCreationButton({
    required this.size,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double radius = size.height * 0.3125;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size.height,
        height: size.height,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: GradientBoxBorder(gradient: AppColors.primaryGradient),
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
            ),
            Center(
              child: AssetIcon(
                AppIcons.list_item_plus,
                color: AppColors.middleGrey,
                size: size.height * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
