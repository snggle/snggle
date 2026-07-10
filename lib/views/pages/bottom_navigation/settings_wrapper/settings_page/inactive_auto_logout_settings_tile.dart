import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/inactive_logout_timeout.dart';
import 'package:snggle/views/widgets/custom/custom_large_list_tile.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class InactivityAutoLogoutSettingsTile extends StatelessWidget {
  const InactivityAutoLogoutSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutoLogoutCubit, AutoLogoutState>(
      buildWhen:
          (
            AutoLogoutState previousState,
            AutoLogoutState currentState,
          ) {
            return previousState.inactivityLogoutEnabledBool != currentState.inactivityLogoutEnabledBool ||
                previousState.inactivityLogoutTimeout != currentState.inactivityLogoutTimeout;
          },
      builder:
          (
            BuildContext context,
            AutoLogoutState state,
          ) {
            return CustomLargeListTile(
              leading: const AssetIcon(
                AppIcons.bottom_navigation_logout,
                size: 42,
              ),
              title:
                  'Logout after inactivity:  ${_getModeLabel(
                    state.inactivityLogoutEnabledBool ? state.inactivityLogoutTimeout : InactivityLogoutTimeout.off,
                  )}',
              onTap: () => _showModeDialog(
                context: context,
                inactivityLogoutTimeout: state.inactivityLogoutEnabledBool ? state.inactivityLogoutTimeout : state.inactivityLogoutTimeout,
              ),
            );
          },
    );
  }

  Future<void> _showModeDialog({
    required BuildContext context,
    required InactivityLogoutTimeout inactivityLogoutTimeout,
  }) async {
    InactivityLogoutTimeout? selectedMode = await showDialog<InactivityLogoutTimeout>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout after inactivity'),
          content: RadioGroup<InactivityLogoutTimeout>(
            groupValue: inactivityLogoutTimeout,
            onChanged: (InactivityLogoutTimeout? selectedMode) {
              if (selectedMode != null) {
                Navigator.of(dialogContext).pop(selectedMode);
              }
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile<InactivityLogoutTimeout>(
                  value: InactivityLogoutTimeout.off,
                  title: Text('Off'),
                ),
                RadioListTile<InactivityLogoutTimeout>(
                  value: InactivityLogoutTimeout.oneMinute,
                  title: Text('1 minute'),
                ),
                RadioListTile<InactivityLogoutTimeout>(
                  value: InactivityLogoutTimeout.fiveMinutes,
                  title: Text('5 minutes'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedMode == null || context.mounted == false) {
      return;
    }
    AutoLogoutCubit autoLogoutCubit = context.read<AutoLogoutCubit>();

    if (selectedMode == InactivityLogoutTimeout.off) {
      await autoLogoutCubit.setInactivityLogoutTimeout(
        inactivityLogoutTimeout: InactivityLogoutTimeout.off,
      );
      await autoLogoutCubit.setInactivityLogoutEnabledBool(
        inactivityLogoutEnabledBool: false,
      );
      return;
    }

    await autoLogoutCubit.setInactivityLogoutTimeout(
      inactivityLogoutTimeout: selectedMode,
    );

    await autoLogoutCubit.setInactivityLogoutEnabledBool(
      inactivityLogoutEnabledBool: true,
    );
  }

  String _getModeLabel(
    InactivityLogoutTimeout inactivityLogoutTimeout,
  ) {
    return switch (inactivityLogoutTimeout) {
      InactivityLogoutTimeout.off => 'Off',
      InactivityLogoutTimeout.oneMinute => '1 minute',
      InactivityLogoutTimeout.fiveMinutes => '5 minutes',
    };
  }
}
