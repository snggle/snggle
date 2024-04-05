import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';

class KeyboardButton extends StatelessWidget {
  final bool disabledBool;
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const KeyboardButton({
    required this.disabledBool,
    required this.child,
    required this.onTap,
    this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9.5),
      onTap: _handleKeyboardButtonTap,
      onLongPress: _handleKeyboardButtonLongPress,
      child: Container(
        color: disabledBool ? AppColors.lightGrey3 : Colors.transparent,
        child: Align(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  void _handleKeyboardButtonTap() {
    if (disabledBool == false) {
      HapticFeedback.lightImpact();
      onTap();
    }
  }

  void _handleKeyboardButtonLongPress() {
    if (onLongPress == null) {
      return;
    }

    if (disabledBool == false) {
      HapticFeedback.lightImpact();
      onLongPress!();
    }
  }
}
