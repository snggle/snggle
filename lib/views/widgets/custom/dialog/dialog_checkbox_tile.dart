import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox.dart';

class DialogCheckboxTile extends StatelessWidget {
  final bool selectedBool;
  final String title;
  final VoidCallback onTap;
  final bool enabledBool;

  const DialogCheckboxTile({
    required this.selectedBool,
    required this.title,
    required this.onTap,
    this.enabledBool = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Opacity(
      opacity: enabledBool ? 1 : 0.3,
      child: Material(
        child: InkWell(
          onTap: enabledBool ? onTap : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
            child: Row(
              children: <Widget>[
                CustomCheckbox(selectedBool: selectedBool, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(title, style: theme.textTheme.labelMedium?.copyWith(color: AppColors.body3)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
