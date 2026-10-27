import 'package:flutter/material.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
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
  final InactivityLogoutTimer inactivityLogoutTimeout;
  final ValueChanged<InactivityLogoutTimer?>? inactivityLogoutTimeoutValueChanged;

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
          trailing: DropdownButton<InactivityLogoutTimer>(
            value: inactivityLogoutTimeout,
            onChanged: timeoutSelectionEnabledBool ? inactivityLogoutTimeoutValueChanged : null,
            items: const <DropdownMenuItem<InactivityLogoutTimer>>[
              DropdownMenuItem<InactivityLogoutTimer>(value: InactivityLogoutTimer.oneMinute, child: Text('1 minute')),
              DropdownMenuItem<InactivityLogoutTimer>(value: InactivityLogoutTimer.fiveMinutes, child: Text('5 minutes')),
            ],
          ),
        ),
      ],
    );
  }
}
