import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';
import 'package:snggle/views/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout/auto_logout_settings_tile.dart';
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
                      autoLogoutCubit.setInactivityEnabledBool(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool),
                  inactivityLogoutTimeout: autoLogoutState.inactivityLogoutTimeout,
                  inactivityLogoutTimeoutValueChanged: (InactivityLogoutTimeout? inactivityLogoutTimeout) =>
                      _handleTimeoutChanged(buildContext, inactivityLogoutTimeout),
                ),
                const Divider(height: 32),
                AutoLogoutSettingsTile(
                  automaticLogoutEnabledBool: autoLogoutState.automaticLogoutMode == AutomaticLogoutMode.on,
                  automaticLogoutEnabledValueChanged: (bool automaticLogoutEnabledBool) =>
                      _handleModeChanged(buildContext, automaticLogoutEnabledBool),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleModeChanged(BuildContext buildContext, bool automaticLogoutEnabledBool) {
    AutomaticLogoutMode automaticLogoutMode = automaticLogoutEnabledBool ? AutomaticLogoutMode.on : AutomaticLogoutMode.off;
    return buildContext.read<AutoLogoutCubit>().setAutomaticLogoutMode(automaticLogoutMode: automaticLogoutMode);
  }

  Future<void> _handleTimeoutChanged(BuildContext buildContext, InactivityLogoutTimeout? inactivityLogoutTimeout) async {
    await buildContext.read<AutoLogoutCubit>().setInactivityLogoutTimeout(inactivityLogoutTimeout: inactivityLogoutTimeout!);
  }
}
