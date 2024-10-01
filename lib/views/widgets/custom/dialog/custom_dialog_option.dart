import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';

class CustomDialogOption extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool autoCloseBool;
  final Gradient? labelGradient;
  final double horizontalPadding;

  const CustomDialogOption({
    required this.label,
    required this.onPressed,
    this.autoCloseBool = true,
    this.labelGradient,
    this.horizontalPadding = 17,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 36,
      child: TextButton(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Colors.transparent),
        ),
        onPressed: () {
          if (autoCloseBool) {
            Navigator.of(context).pop();
          }
          onPressed();
        },
        child: labelGradient != null
            ? GradientText(label, gradient: labelGradient!, textStyle: textTheme.bodyMedium!.copyWith(height: 1))
            : Text(label, style: textTheme.bodyMedium!.copyWith(color: AppColors.body3, height: 1)),
      ),
    );
  }
}
