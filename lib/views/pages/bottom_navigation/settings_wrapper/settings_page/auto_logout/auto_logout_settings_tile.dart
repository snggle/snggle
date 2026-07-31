import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/views/widgets/custom/custom_large_list_tile.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class AutoLogoutSettingsTile extends StatelessWidget {
  const AutoLogoutSettingsTile({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<AutoLogoutCubit, AutoLogoutState>(
      buildWhen: (AutoLogoutState previousAutoLogoutState, AutoLogoutState currentAutoLogoutState) {
        bool automaticLogoutModeChangedBool = previousAutoLogoutState.automaticLogoutMode != currentAutoLogoutState.automaticLogoutMode;
        return automaticLogoutModeChangedBool;
      },
      builder: (BuildContext context, AutoLogoutState autoLogoutState) {
        return CustomLargeListTile(
          leading: const AssetIcon(
            AppIcons.bottom_navigation_logout,
            size: 42,
          ),
          title: 'Automatic logout: ${_getModeLabel(autoLogoutState.automaticLogoutMode)}',
          onTap: () => _handleTap(autoLogoutState.automaticLogoutMode, buildContext),
        );
      },
    );
  }

  String _getModeLabel(AutomaticLogoutMode automaticLogoutMode) {
    return switch (automaticLogoutMode) {
      AutomaticLogoutMode.off => 'Off',
      AutomaticLogoutMode.on => 'On',
    };
  }

  Future<void> _handleTap(AutomaticLogoutMode automaticLogoutMode, BuildContext buildContext) async {
    AutomaticLogoutMode? selectedAutomaticLogoutMode = await _showModeDialog(buildContext, automaticLogoutMode);

    final bool selectionUnavailableBool = selectedAutomaticLogoutMode == null || buildContext.mounted == false;

    if (selectionUnavailableBool) {
      return;
    }

    await buildContext.read<AutoLogoutCubit>().setAutomaticLogoutMode(automaticLogoutMode: selectedAutomaticLogoutMode);
  }

  Future<AutomaticLogoutMode?> _showModeDialog(BuildContext buildContext, AutomaticLogoutMode automaticLogoutMode) {
    return showDialog<AutomaticLogoutMode>(
      context: buildContext,
      builder: (BuildContext dialogBuildContext) {
        return AlertDialog(
          title: const Text('Automatic logout'),
          content: RadioGroup<AutomaticLogoutMode>(
            groupValue: automaticLogoutMode,
            onChanged: (AutomaticLogoutMode? selectedAutomaticLogoutMode) {
              if (selectedAutomaticLogoutMode != null) {
                Navigator.of(dialogBuildContext).pop(selectedAutomaticLogoutMode);
              }
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile<AutomaticLogoutMode>(
                  value: AutomaticLogoutMode.off,
                  title: Text('Off'),
                ),
                RadioListTile<AutomaticLogoutMode>(value: AutomaticLogoutMode.on, title: Text('Immediately')),
              ],
            ),
          ),
        );
      },
    );
  }
}
