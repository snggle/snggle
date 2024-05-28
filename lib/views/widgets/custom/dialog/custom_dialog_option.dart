import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class CustomDialogOption extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomDialogOption({
    required this.label,
    required this.onPressed,
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
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Colors.transparent),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          onPressed();
        },
        child: Text(label, style: textTheme.bodyMedium!.copyWith(color: AppColors.body3)),
      ),
    );
  }
}
