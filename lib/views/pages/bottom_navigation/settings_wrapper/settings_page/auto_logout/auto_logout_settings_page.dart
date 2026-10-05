import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout/auto_logout_settings_tile.dart';
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout/inactive_auto_logout_settings_tile.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
class AutoLogoutSettingsPage extends StatelessWidget {
  const AutoLogoutSettingsPage({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return const CustomScaffold(
      title: 'Auto-Logout',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InactivityAutoLogoutSettingsTile(),
            Divider(height: 32),
            AutoLogoutSettingsTile(),
          ],
        ),
      ),
    );
  }
}