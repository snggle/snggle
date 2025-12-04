import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class CustomDialogOption extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool autoCloseBool;
  final Color? labelColor;
  final double horizontalPadding;

  const CustomDialogOption({
    required this.label,
    required this.onPressed,
    this.autoCloseBool = true,
    this.labelColor,
    this.horizontalPadding = 17,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool buttonEnabledBool = onPressed != null;

    return SizedBox(
      height: 36,
      child: TextButton(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Colors.transparent),
        ),
        onPressed: _buttonEnabledBool ? () => _pressButton(context) : null,
        child: Text(
          label,
          style: textTheme.bodyMedium!.copyWith(
            color: buttonEnabledBool ? (labelColor ?? AppColors.body3) : AppColors.middleGrey,
            height: 1,
          ),
        ),
      ),
    );
  }

  bool get _buttonEnabledBool => onPressed != null;

  void _pressButton(BuildContext context) {
    if (autoCloseBool) {
      Navigator.of(context).pop();
    }
    onPressed?.call();
  }
}
