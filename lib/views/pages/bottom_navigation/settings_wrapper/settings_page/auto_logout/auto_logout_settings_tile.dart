import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';

class AutoLogoutSettingsTile extends StatelessWidget {
  const AutoLogoutSettingsTile({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<AutoLogoutCubit, AutoLogoutState>(
      buildWhen: (
          AutoLogoutState previousAutoLogoutState,
          AutoLogoutState currentAutoLogoutState,
          ) {
        return previousAutoLogoutState.automaticLogoutMode !=
            currentAutoLogoutState.automaticLogoutMode;
      },
      builder: (
          BuildContext buildContext,
          AutoLogoutState autoLogoutState,
          ) {
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Logout when the app is in the background'),
          subtitle: const Text(
            'Log out immediately when the app goes into the background.',
          ),
          value: autoLogoutState.automaticLogoutMode == AutomaticLogoutMode.on,
          activeTrackColor: Theme.of(buildContext).colorScheme.primary,
          activeThumbColor: Theme.of(buildContext).colorScheme.surface,
          onChanged: (bool automaticLogoutEnabledBool) => _handleModeChanged(
            buildContext: buildContext,
            automaticLogoutEnabledBool: automaticLogoutEnabledBool,
          ),
        );
      },
    );
  }

  Future<void> _handleModeChanged({
    required BuildContext buildContext,
    required bool automaticLogoutEnabledBool,
  }) async {
    AutomaticLogoutMode automaticLogoutMode = automaticLogoutEnabledBool
        ? AutomaticLogoutMode.on
        : AutomaticLogoutMode.off;

    await buildContext.read<AutoLogoutCubit>().setAutomaticLogoutMode(
      automaticLogoutMode: automaticLogoutMode,
    );
  }
}