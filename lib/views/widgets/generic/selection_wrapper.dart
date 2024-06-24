import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';
import 'package:sprung/sprung.dart';

class SelectionWrapper extends StatelessWidget {
  final bool selectedBool;
  final Widget child;
  final ValueChanged<bool> onSelectValueChanged;
  final EdgeInsets padding;

  const SelectionWrapper({
    required this.selectedBool,
    required this.child,
    required this.onSelectValueChanged,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelectValueChanged(selectedBool == false),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: child),
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: padding,
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: padding,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  switchInCurve: Sprung.custom(mass: 1, stiffness: 100, damping: 15),
                  switchOutCurve: Sprung.custom(mass: 1, stiffness: 100, damping: 15),
                  child: selectedBool
                      ? GradientIcon(
                          AppIcons.select_container_selected,
                          size: 16,
                          gradient: AppColors.primaryGradient,
                        )
                      : Opacity(
                          opacity: 0.3,
                          child: GradientIcon(AppIcons.select_container_unselected, size: 16, gradient: AppColors.primaryGradient),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
