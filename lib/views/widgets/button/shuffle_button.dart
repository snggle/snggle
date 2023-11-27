import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class ShuffleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool shuffleEnabledBool;

  const ShuffleButton({
    required this.onPressed,
    this.shuffleEnabledBool = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget shuffleButtonWidget = Text(
      'SHUFFLE',
      style: TextStyle(
        fontSize: 14,
        letterSpacing: 5,
        fontWeight: FontWeight.w400,
        color: AppColors.body3,
      ),
    );

    if (shuffleEnabledBool) {
      shuffleButtonWidget = Transform.scale(scaleY: -1, child: shuffleButtonWidget);
    }

    return TextButton(
      onPressed: onPressed,
      child: shuffleButtonWidget,
    );
  }
}
