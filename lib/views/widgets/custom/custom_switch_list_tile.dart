import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_switch.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    required this.title,
    required this.valueBool,
    required this.valueChanged,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool valueBool;
  final ValueChanged<bool>? valueChanged;

  @override
  Widget build(BuildContext buildContext) {
    return MergeSemantics(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        enabled: valueChanged != null,
        title: Text(title),
        subtitle: switch (subtitle) {
          String subtitle => Text(subtitle),
          null => null,
        },
        onTap: valueChanged == null ? null : () => valueChanged?.call(!valueBool),
        trailing: ExcludeFocus(
          child: CustomSwitch(
            valueBool: valueBool,
            valueChanged: valueChanged,
          ),
        ),
      ),
    );
  }
}
