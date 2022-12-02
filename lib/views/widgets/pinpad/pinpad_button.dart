import 'package:flutter/material.dart';

class PinpadButton extends StatelessWidget {
  final int? numberValue;
  final IconData? iconData;
  final VoidCallback onTap;

  const PinpadButton.number({
    required this.numberValue,
    required this.onTap,
    super.key,
  }) : iconData = null;

  const PinpadButton.icon({
    required this.iconData,
    required this.onTap,
    super.key,
  }) : numberValue = null;

  @override
  Widget build(BuildContext context) {
    late Widget buttonChild;
    if (numberValue != null) {
      buttonChild = Text(
        numberValue.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
      );
    } else {
      buttonChild = Icon(iconData!);
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
          color: Colors.grey[50],
        ),
        padding: const EdgeInsets.all(4),
        child: TextButton(
          key: Key('pinpad_button_$numberValue'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[50],
            foregroundColor: Colors.black,
          ),
          onPressed: onTap,
          child: buttonChild,
        ),
      ),
    );
  }
}
