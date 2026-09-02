import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox.dart';

class PasswordCharacterCheckbox extends StatelessWidget {
  final bool selectedBool;
  final String title;
  final VoidCallback onTapVoidCallback;

  const PasswordCharacterCheckbox({
    required this.selectedBool,
    required this.title,
    required this.onTapVoidCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapVoidCallback,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            CustomCheckbox(selectedBool: selectedBool, squareCheckboxBool: true),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.body3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
