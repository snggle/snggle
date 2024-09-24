import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/config/app_colors.dart';

class GradientOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double? width;
  final double borderRadius;
  final double letterSpacing;
  final EdgeInsets padding;

  const GradientOutlinedButton.large({
    required this.label,
    this.onPressed,
    this.icon,
    super.key,
  })  : width = double.infinity,
        letterSpacing = 1.5,
        borderRadius = 12,
        padding = const EdgeInsets.symmetric(vertical: 16.5, horizontal: 31);

  const GradientOutlinedButton.small({
    required this.label,
    this.onPressed,
    this.icon,
    super.key,
  })  : width = null,
        letterSpacing = 0.5,
        borderRadius = 7,
        padding = const EdgeInsets.symmetric(vertical: 9.5, horizontal: 31);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Opacity(
      opacity: onPressed == null ? 0.3 : 1,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: padding.left),
          decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: RadialGradient(radius: 7, center: Alignment.topLeft, colors: AppColors.primaryGradient.colors),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                icon!,
                const SizedBox(width: 6),
              ],
              Padding(
                padding: EdgeInsets.symmetric(vertical: padding.top),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.body3,
                    letterSpacing: letterSpacing,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
