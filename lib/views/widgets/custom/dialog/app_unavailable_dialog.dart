import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/native/app_launch_mode.dart';
import 'package:snggle/shared/native/autofill_auth/native_autofill_auth.dart';
import 'package:snggle/shared/native/autofill_save/native_autofill_save.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

class AppUnavailableDialog extends StatefulWidget {
  final AppLaunchMode appLaunchMode;

  const AppUnavailableDialog({
    required this.appLaunchMode,
    super.key,
  });

  @override
  State<AppUnavailableDialog> createState() => _AppUnavailableDialogState();
}

class _AppUnavailableDialogState extends State<AppUnavailableDialog> {
  late final TapGestureRecognizer privacyPolicyTapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    privacyPolicyTapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        AutoRouter.of(context).push(const PrivacyPolicyRoute());
      };
  }

  @override
  void dispose() {
    privacyPolicyTapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
          _getFinishAction(widget.appLaunchMode);
      },
      child: CustomDialog(
        title: 'The app is unavailable',
        backgroundColor: AppColors.body2.withValues(alpha: 0.5),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text.rich(
            TextSpan(
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.body3,
                height: 1.25,
              ),
              children: const <InlineSpan>[
                TextSpan(
                  text: 'Please open main Snggle app and setup Master Key first.',
                ),
              ],
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Confirm',
            autoCloseBool: false,
            onPressed: () async => _getFinishAction(widget.appLaunchMode),
          ),
        ],
      ),
    );
  }

  Future<void> _getFinishAction(AppLaunchMode mode) {
    return switch (mode) {
      AppLaunchMode.autofillAuth => NativeAutofillAuth.cancel(),
      AppLaunchMode.autofillSave => NativeAutofillSave.cancel(),
      AppLaunchMode.main => throw StateError(
        'No finish action for AppLaunchMode.main',
      ),
    };
  }
}
