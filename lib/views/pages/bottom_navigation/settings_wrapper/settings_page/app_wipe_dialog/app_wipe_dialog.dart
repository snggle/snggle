import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/app_wipe_dialog/app_wipe_dialog_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/app_wipe_dialog/app_wipe_dialog_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';

class AppWipeDialog extends StatefulWidget {
  const AppWipeDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AppWipeDialogState();
}

class _AppWipeDialogState extends State<AppWipeDialog> {
  late final AppWipeDialogCubit appWipeDialogCubit = AppWipeDialogCubit(
    applicationWipedCallback: _resetRouter,
  );

  @override
  void dispose() {
    super.dispose();
    appWipeDialogCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AppWipeDialogCubit, AppWipeDialogState>(
      bloc: appWipeDialogCubit,
      builder: (BuildContext context, AppWipeDialogState appWipeDialogState) {
        if (appWipeDialogState.wipeInProgressBool) {
          return const CustomLoadingDialog(title: 'WIPE APPLICATION');
        }

        return CustomDialog(
          title: 'WIPE APPLICATION',
          content: Column(
            children: <Widget>[
              GradientText(
                'Are you sure you want to wipe the application? This action cannot be undone and you will lose all your data!',
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFFFF5050), Color(0xFF939393)],
                ),
                textStyle: textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          options: <CustomDialogOption>[
            CustomDialogOption(
              label: 'Cancel',
              onPressed: () {},
            ),
            CustomDialogOption(
              autoCloseBool: false,
              label: appWipeDialogState.confirmationsLeft != 0 ? 'Confirm (${appWipeDialogState.confirmationsLeft})' : 'Wipe',
              labelGradient: const LinearGradient(
                colors: <Color>[Color(0xFFFF5050), Color(0xFF939393)],
              ),
              onPressed: appWipeDialogCubit.confirm,
            ),
          ],
        );
      },
    );
  }

  void _resetRouter() {
    AutoRouter.of(context).pushAndPopUntil(const SplashRoute(), predicate: (_) => false);
  }
}
