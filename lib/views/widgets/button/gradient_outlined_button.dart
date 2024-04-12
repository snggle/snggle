import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/config/app_colors.dart';

class GradientOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const GradientOutlinedButton({
    required this.label,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.5),
          decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: RadialGradient(radius: 7, center: Alignment.topLeft, colors: AppColors.primaryGradient.colors),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: textTheme.labelMedium?.copyWith(color: AppColors.body3),
            ),
          ),
        ),
      ),
    );
  }
}
