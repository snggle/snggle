import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/config/app_colors.dart';

class SquareOutlinedButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onTap;
  final double radius;

  const SquareOutlinedButton({
    required this.icon,
    required this.onTap,
    this.radius = 26,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.topCenter,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Container(
            decoration: BoxDecoration(
              border: GradientBoxBorder(
                gradient: AppColors.primaryGradient,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}
