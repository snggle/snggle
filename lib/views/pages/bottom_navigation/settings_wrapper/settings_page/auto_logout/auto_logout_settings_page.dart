import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout/background_logout_settings_tile.dart';
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout/inactive_auto_logout_settings_tile.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
class AutoLogoutSettingsPage extends StatelessWidget {
  const AutoLogoutSettingsPage({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return CustomScaffold(
      title: 'Auto-Logout',
      body: BlocBuilder<AutoLogoutCubit, AutoLogoutState>(
        builder: (BuildContext buildContext, AutoLogoutState autoLogoutState) {
          AutoLogoutCubit autoLogoutCubit = buildContext.read<AutoLogoutCubit>();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InactivityAutoLogoutSettingsTile(
                  inactivityLogoutEnabledBool: autoLogoutState.inactivityLogoutEnabledBool,
                  inactivityLogoutEnabledValueChanged: (bool inactivityLogoutEnabledBool) =>
                      autoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool),
                  inactivityLogoutTimeout: autoLogoutState.inactivityLogoutTimeout,
                  inactivityLogoutTimeoutValueChanged: (InactivityLogoutTimeout? inactivityLogoutTimeout) =>
                      _handleTimeoutChanged(buildContext, inactivityLogoutTimeout),
                ),
                const Divider(height: 32),
                BackgroundLogoutSettingsTile(
                  backgroundLogoutEnabledBool: autoLogoutState.backgroundLogoutMode == BackgroundLogoutMode.on,
                  backgroundLogoutEnabledValueChanged: (bool backgroundLogoutEnabledBool) =>
                      _handleModeChanged(buildContext, backgroundLogoutEnabledBool),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleModeChanged(BuildContext buildContext, bool backgroundLogoutEnabledBool) {
    BackgroundLogoutMode backgroundLogoutMode = backgroundLogoutEnabledBool ? BackgroundLogoutMode.on : BackgroundLogoutMode.off;
    return buildContext.read<AutoLogoutCubit>().setBackgroundLogoutMode(backgroundLogoutMode: backgroundLogoutMode);
  }

  Future<void> _handleTimeoutChanged(BuildContext buildContext, InactivityLogoutTimeout? inactivityLogoutTimeout) async {
    await buildContext.read<AutoLogoutCubit>().setInactivityLogoutTimeout(inactivityLogoutTimeout: inactivityLogoutTimeout!);
  }
}
