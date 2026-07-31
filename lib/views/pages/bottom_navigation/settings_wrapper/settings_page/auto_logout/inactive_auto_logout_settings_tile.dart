import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactive_logout_timeout.dart';
import 'package:snggle/views/widgets/custom/custom_large_list_tile.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class InactivityAutoLogoutSettingsTile extends StatelessWidget {
  const InactivityAutoLogoutSettingsTile({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<AutoLogoutCubit, AutoLogoutState>(
      buildWhen: (AutoLogoutState previousAutoLogoutState, AutoLogoutState currentAutoLogoutState) {
        return previousAutoLogoutState.inactivityLogoutEnabledBool != currentAutoLogoutState.inactivityLogoutEnabledBool ||
            previousAutoLogoutState.inactivityLogoutTimeout != currentAutoLogoutState.inactivityLogoutTimeout;
      },
      builder: (BuildContext buildContext, AutoLogoutState autoLogoutState) {
        InactivityLogoutTimeout selectedInactivityLogoutTimeout = autoLogoutState.inactivityLogoutEnabledBool
            ? autoLogoutState.inactivityLogoutTimeout
            : InactivityLogoutTimeout.off;
        return CustomLargeListTile(
          leading: const AssetIcon(
            AppIcons.bottom_navigation_logout,
            size: 42,
          ),
          title:
              'Logout after inactivity:  ${_getModeLabel(
                autoLogoutState.inactivityLogoutEnabledBool ? autoLogoutState.inactivityLogoutTimeout : InactivityLogoutTimeout.off,
              )}',
          onTap: () => _handleTap(buildContext: buildContext, inactivityLogoutTimeout: selectedInactivityLogoutTimeout),
        );
      },
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

  Future<void> _handleTap({
    required BuildContext buildContext,
    required InactivityLogoutTimeout inactivityLogoutTimeout,
  }) async {
    InactivityLogoutTimeout? selectedInactivityLogoutTimeout = await _showModeDialog(
      buildContext: buildContext,
      inactivityLogoutTimeout: inactivityLogoutTimeout,
    );

    bool selectionUnavailableBool = selectedInactivityLogoutTimeout == null || buildContext.mounted == false;

    if (selectionUnavailableBool) {
      return;
    }

    InactivityLogoutTimeout resolvedInactivityLogoutTimeout = selectedInactivityLogoutTimeout ?? inactivityLogoutTimeout;
    bool inactivityLogoutEnabledBool = resolvedInactivityLogoutTimeout != InactivityLogoutTimeout.off;
    AutoLogoutCubit autoLogoutCubit = buildContext.read<AutoLogoutCubit>();

    await autoLogoutCubit.setInactivityLogoutTimeout(inactivityLogoutTimeout: resolvedInactivityLogoutTimeout);
    await autoLogoutCubit.setInactivityEnabledBool(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool);
  }

  Future<InactivityLogoutTimeout?> _showModeDialog({
    required BuildContext buildContext,
    required InactivityLogoutTimeout inactivityLogoutTimeout,
  }) async {
    return showDialog<InactivityLogoutTimeout>(
      context: buildContext,
      builder: (BuildContext dialogBuildContext) {
        return AlertDialog(
          title: const Text('Logout after inactivity'),
          content: RadioGroup<InactivityLogoutTimeout>(
            groupValue: inactivityLogoutTimeout,
            onChanged: (InactivityLogoutTimeout? selectedInactivityLogoutTimeout) {
              bool selectedModeAvailableBool = selectedInactivityLogoutTimeout != null;
              if (selectedModeAvailableBool) {
                Navigator.of(dialogBuildContext).pop(selectedInactivityLogoutTimeout);
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
  }
}
