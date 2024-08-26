import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/config/app_colors.dart';

class CreateTemplateFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateTemplateFloatingButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 54,
        height: 54,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.body2,
          shape: BoxShape.circle,
          border: GradientBoxBorder(
            gradient: AppColors.primaryGradient,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.add,
          color: AppColors.body3,
          size: 30,
        ),
      ),
    );
  }
}
