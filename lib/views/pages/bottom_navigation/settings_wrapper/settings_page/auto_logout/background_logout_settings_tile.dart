import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_switch_list_tile.dart';

class BackgroundLogoutSettingsTile extends StatelessWidget {
  const BackgroundLogoutSettingsTile({
    required this.backgroundLogoutEnabledBool,
    required this.backgroundLogoutEnabledValueChanged,
    super.key,
  });

  final bool backgroundLogoutEnabledBool;
  final ValueChanged<bool>? backgroundLogoutEnabledValueChanged;

  @override
  Widget build(BuildContext buildContext) {
    return CustomSwitchListTile(
      title: 'Logout when the app is in the background',
      valueBool: backgroundLogoutEnabledBool,
      valueChanged: backgroundLogoutEnabledValueChanged,
      subtitle: 'Log out immediately when the app goes into the background.',
    );
  }
}
