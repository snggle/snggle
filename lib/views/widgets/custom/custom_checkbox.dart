import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:sprung/sprung.dart';

class CustomCheckbox extends StatelessWidget {
  final bool selectedBool;
  final bool squareCheckboxBool;
  final double size;

  const CustomCheckbox({
    required this.selectedBool,
    this.squareCheckboxBool = false,
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
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5)),
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
                  ? AssetIcon(squareCheckboxBool ? AppIcons.checkbox_selected_square : AppIcons.checkbox_selected, size: size)
                  : AssetIcon(squareCheckboxBool ? AppIcons.checkbox_unselected_square : AppIcons.checkbox_unselected, size: size),
            ),
          ),
        ],
      ),
    );
  }
}
