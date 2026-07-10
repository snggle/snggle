import 'package:flutter/material.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';
import 'package:snggle/views/widgets/custom/custom_switch_list_tile.dart';

class InactivityAutoLogoutSettingsTile extends StatelessWidget {
  const InactivityAutoLogoutSettingsTile({
    required this.inactivityLogoutEnabledBool,
    required this.inactivityLogoutEnabledValueChanged,
    required this.inactivityLogoutTimeout,
    required this.inactivityLogoutTimeoutValueChanged,
    super.key,
  });

  final bool inactivityLogoutEnabledBool;
  final ValueChanged<bool>? inactivityLogoutEnabledValueChanged;
  final InactivityLogoutTimeout inactivityLogoutTimeout;
  final ValueChanged<InactivityLogoutTimeout?>? inactivityLogoutTimeoutValueChanged;

  @override
  Widget build(BuildContext buildContext) {
    bool timeoutSelectionEnabledBool = inactivityLogoutEnabledBool && inactivityLogoutTimeoutValueChanged != null;

    return Column(
      children: <Widget>[
        CustomSwitchListTile(
          title: 'Logout after inactivity',
          valueBool: inactivityLogoutEnabledBool,
          valueChanged: inactivityLogoutEnabledValueChanged,
          subtitle: 'Log out after a period without interaction.',
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          enabled: timeoutSelectionEnabledBool,
          title: const Text('Inactivity timeout'),
          trailing: DropdownButton<InactivityLogoutTimeout>(
            value: inactivityLogoutTimeout,
            onChanged: timeoutSelectionEnabledBool ? inactivityLogoutTimeoutValueChanged : null,
            items: const <DropdownMenuItem<InactivityLogoutTimeout>>[
              DropdownMenuItem<InactivityLogoutTimeout>(value: InactivityLogoutTimeout.oneMinute, child: Text('1 minute')),
              DropdownMenuItem<InactivityLogoutTimeout>(value: InactivityLogoutTimeout.fiveMinutes, child: Text('5 minutes')),
            ],
          ),
        ),
      ],
    );
  }
}
