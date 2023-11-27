import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';

class PinpadKeyboardButton extends StatelessWidget {
  final int? number;
  final Widget? icon;
  final VoidCallback onTap;

  const PinpadKeyboardButton.number({
    required this.number,
    required this.onTap,
    super.key,
  }) : icon = null;

  const PinpadKeyboardButton.icon({
    required this.icon,
    required this.onTap,
    super.key,
  }) : number = null;

  @override
  Widget build(BuildContext context) {
    late Widget buttonChild;
    if (number != null) {
      buttonChild = Text(
        '$number',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 32,
          letterSpacing: 4,
          color: AppColors.body1,
        ),
      );
    } else {
      buttonChild = icon!;
    }

    return Container(
      margin: const EdgeInsets.all(2.0),
      height: double.infinity,
      child: TextButton(
        onPressed: _handleButtonPressed,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Container(
            padding: const EdgeInsets.all(6.0),
            child: buttonChild,
          ),
        ),
      ),
    );
  }

  void _handleButtonPressed() {
    onTap();
    unawaited(HapticFeedback.lightImpact());
  }
}
