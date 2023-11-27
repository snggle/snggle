import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? color;

  const CustomTextButton({
    required this.title,
    required this.onPressed,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(title.toUpperCase(), style: TextStyle(color: color)),
    );
  }
}
