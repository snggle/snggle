import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_switch_list_tile.dart';

class AutoLogoutSettingsTile extends StatelessWidget {
  const AutoLogoutSettingsTile({
    required this.automaticLogoutEnabledBool,
    required this.automaticLogoutEnabledValueChanged,
    super.key,
  });

  final bool automaticLogoutEnabledBool;
  final ValueChanged<bool>? automaticLogoutEnabledValueChanged;

  @override
  Widget build(BuildContext buildContext) {
    return CustomSwitchListTile(
      title: 'Logout when the app is in the background',
      valueBool: automaticLogoutEnabledBool,
      valueChanged: automaticLogoutEnabledValueChanged,
      subtitle: 'Log out immediately when the app goes into the background.',
    );
  }
}
