import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/app_wipe_dialog/app_wipe_dialog.dart';
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout/auto_logout_settings_tile.dart';
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout/inactive_auto_logout_settings_tile.dart';
import 'package:snggle/views/widgets/custom/custom_large_list_tile.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

@RoutePage()
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Settings',
      popButtonVisible: false,
      body: Column(
        children: <Widget>[
          CustomLargeListTile(
            leading: const AssetIcon(AppIcons.settings_change_app_pin, size: 42),
            title: 'Change Application PIN',
            onTap: () => context.router.push(AppEnterPinRoute(appPinType: AppPinType.changePin)),
          ),
          const AutoLogoutSettingsTile(),
          const InactivityAutoLogoutSettingsTile(),
          CustomLargeListTile(
            leading: const AssetIcon(AppIcons.settings_privacy_policy, size: 42),
            title: 'Privacy policy',
            onTap: () => context.router.push(const PrivacyPolicyRoute()),
          ),
          CustomLargeListTile(
            leading: const AssetIcon(AppIcons.settings_warning, size: 42),
            title: 'Wipe Application',
            titleGradient: const LinearGradient(
              colors: <Color>[Color(0xFFFF5050), Color(0xFF939393)],
            ),
            onTap: _handleWipeApplicationButtonPress,
          ),
        ],
      ),
    );
  }

  Future<void> _handleWipeApplicationButtonPress() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => const AppWipeDialog(),
    );
  }
}
