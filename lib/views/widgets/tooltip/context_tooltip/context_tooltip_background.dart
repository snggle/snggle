import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class ContextTooltipBackground extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double borderWeight;
  final double? maxPopupWidth;

  const ContextTooltipBackground({
    required this.child,
    this.borderRadius = 16,
    this.borderWeight = 1,
    this.maxPopupWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            constraints: maxPopupWidth != null ? BoxConstraints(maxWidth: maxPopupWidth!) : null,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: AppColors.middleGrey, width: borderWeight),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
