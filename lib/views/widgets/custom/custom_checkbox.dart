import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';
import 'package:sprung/sprung.dart';

class CustomCheckbox extends StatelessWidget {
  final bool selectedBool;
  final double size;

  const CustomCheckbox({
    required this.selectedBool,
    this.size = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              switchInCurve: Sprung.custom(mass: 1, stiffness: 100, damping: 15),
              switchOutCurve: Sprung.custom(mass: 1, stiffness: 100, damping: 15),
              child: selectedBool
                  ? GradientIcon(
                      AppIcons.select_container_selected,
                      size: size,
                      gradient: AppColors.primaryGradient,
                    )
                  : Opacity(
                      opacity: 0.3,
                      child: GradientIcon(AppIcons.select_container_unselected, size: size, gradient: AppColors.primaryGradient),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
