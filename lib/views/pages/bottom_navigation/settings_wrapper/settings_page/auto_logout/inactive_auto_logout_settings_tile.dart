import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactive_logout_timeout.dart';

class InactivityAutoLogoutSettingsTile extends StatelessWidget {
  const InactivityAutoLogoutSettingsTile({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<AutoLogoutCubit, AutoLogoutState>(
      buildWhen: (
          AutoLogoutState previousAutoLogoutState,
          AutoLogoutState currentAutoLogoutState,
          ) {
        return previousAutoLogoutState.inactivityLogoutEnabledBool !=
            currentAutoLogoutState.inactivityLogoutEnabledBool ||
            previousAutoLogoutState.inactivityLogoutTimeout !=
                currentAutoLogoutState.inactivityLogoutTimeout;
      },
      builder: (
          BuildContext buildContext,
          AutoLogoutState autoLogoutState,
          ) {
        return Column(
          children: <Widget>[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Logout after inactivity'),
              subtitle: const Text(
                'Log out after a period without interaction.',
              ),
              value: autoLogoutState.inactivityLogoutEnabledBool,
              onChanged: (bool inactivityLogoutEnabledBool) =>
                  _handleEnabledChanged(
                    buildContext: buildContext,
                    inactivityLogoutEnabledBool: inactivityLogoutEnabledBool,
                    inactivityLogoutTimeout: autoLogoutState.inactivityLogoutTimeout,
                  ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              enabled: autoLogoutState.inactivityLogoutEnabledBool,
              title: const Text('Inactivity timeout'),
              trailing: DropdownButton<InactivityLogoutTimeout>(
                value: _resolveTimeout(
                  autoLogoutState.inactivityLogoutTimeout,
                ),
                onChanged: autoLogoutState.inactivityLogoutEnabledBool
                    ? (InactivityLogoutTimeout? inactivityLogoutTimeout) =>
                    _handleTimeoutChanged(
                      buildContext: buildContext,
                      inactivityLogoutTimeout: inactivityLogoutTimeout,
                    )
                    : null,
                items: const <DropdownMenuItem<InactivityLogoutTimeout>>[
                  DropdownMenuItem<InactivityLogoutTimeout>(
                    value: InactivityLogoutTimeout.oneMinute,
                    child: Text('1 minute'),
                  ),
                  DropdownMenuItem<InactivityLogoutTimeout>(
                    value: InactivityLogoutTimeout.fiveMinutes,
                    child: Text('5 minutes'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  InactivityLogoutTimeout _resolveTimeout(
      InactivityLogoutTimeout inactivityLogoutTimeout,
      ) {
    return inactivityLogoutTimeout == InactivityLogoutTimeout.off
        ? InactivityLogoutTimeout.oneMinute
        : inactivityLogoutTimeout;
  }

  Future<void> _handleEnabledChanged({
    required BuildContext buildContext,
    required bool inactivityLogoutEnabledBool,
    required InactivityLogoutTimeout inactivityLogoutTimeout,
  }) async {
    AutoLogoutCubit autoLogoutCubit = buildContext.read<AutoLogoutCubit>();
    bool timeoutUnavailableBool =
        inactivityLogoutTimeout == InactivityLogoutTimeout.off;

    if (inactivityLogoutEnabledBool && timeoutUnavailableBool) {
      await autoLogoutCubit.setInactivityLogoutTimeout(
        inactivityLogoutTimeout: _resolveTimeout(inactivityLogoutTimeout),
      );
    }

    await autoLogoutCubit.setInactivityEnabledBool(
      inactivityLogoutEnabledBool: inactivityLogoutEnabledBool,
    );
  }

  Future<void> _handleTimeoutChanged({
    required BuildContext buildContext,
    required InactivityLogoutTimeout? inactivityLogoutTimeout,
  }) async {
    if (inactivityLogoutTimeout == null) {
      return;
    }

    await buildContext.read<AutoLogoutCubit>().setInactivityLogoutTimeout(
      inactivityLogoutTimeout: inactivityLogoutTimeout,
    );
  }
}