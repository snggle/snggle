import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/automatic_logout_mode.dart';
import 'package:snggle/views/widgets/custom/custom_large_list_tile.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class AutoLogoutSettingsTile extends StatelessWidget {
  const AutoLogoutSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutoLogoutCubit, AutoLogoutState>(
      buildWhen:
          (
            AutoLogoutState previousState,
            AutoLogoutState currentState,
          ) {
            return previousState.automaticLogoutMode != currentState.automaticLogoutMode;
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
              title: 'Automatic logout: ${_getModeLabel(state.automaticLogoutMode)}',
              onTap: () => _showModeDialog(
                context: context,
                automaticLogoutMode: state.automaticLogoutMode,
              ),
            );
          },
    );
  }

  Future<void> _showModeDialog({
    required BuildContext context,
    required AutomaticLogoutMode automaticLogoutMode,
  }) async {
    AutomaticLogoutMode? selectedMode = await showDialog<AutomaticLogoutMode>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Automatic logout'),
          content: RadioGroup<AutomaticLogoutMode>(
            groupValue: automaticLogoutMode,
            onChanged: (AutomaticLogoutMode? selectedMode) {
              if (selectedMode != null) {}
              Navigator.of(dialogContext).pop(selectedMode);
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile<AutomaticLogoutMode>(
                  value: AutomaticLogoutMode.off,
                  title: Text('Off'),
                ),
                RadioListTile<AutomaticLogoutMode>(
                  value: AutomaticLogoutMode.on,
                  title: Text('Immediately'),
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

    await context.read<AutoLogoutCubit>().setAutomaticLogoutMode(
      automaticLogoutMode: selectedMode,
    );
  }

  String _getModeLabel(
    AutomaticLogoutMode automaticLogoutMode,
  ) {
    return switch (automaticLogoutMode) {
      AutomaticLogoutMode.off => 'Off',
      AutomaticLogoutMode.on => 'On',
    };
  }
}
