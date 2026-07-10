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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        enabled: valueChanged != null,
        title: Text(
          title,
          style: const TextStyle(height: 1.0),
        ),
        subtitle: switch (subtitle) {
          String subtitle => Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(subtitle),
          ),
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
