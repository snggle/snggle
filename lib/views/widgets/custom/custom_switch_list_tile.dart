import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    required this.title,
    required this.valueBool,
    required this.valueChanged,
    this.subtitle,
    super.key,
  });

  final String title;
  final bool valueBool;
  final ValueChanged<bool>? valueChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext buildContext) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: switch (subtitle) {
        String subtitle => Text(subtitle),
        null => null,
      },
      value: valueBool,
      onChanged: valueChanged,
      thumbColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> widgetStateSet) {
          bool disabledBool = widgetStateSet.contains(WidgetState.disabled);
          if (disabledBool) {
            return AppColors.darkGrey;
          }
          bool selectedBool = widgetStateSet.contains(WidgetState.selected);
          return selectedBool ? AppColors.body2 : AppColors.body3;
        },
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> widgetStateSet) {
          bool disabledBool = widgetStateSet.contains(WidgetState.disabled);
          if (disabledBool) {
            return AppColors.lightGrey2;
          }
          bool selectedBool = widgetStateSet.contains(WidgetState.selected);
          return selectedBool ? AppColors.body3 : AppColors.middleGrey;
        },
      ),
      trackOutlineColor: const WidgetStatePropertyAll<Color>(
        Colors.transparent,
      ),
    );
  }
}