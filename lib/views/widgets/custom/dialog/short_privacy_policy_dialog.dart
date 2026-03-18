import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/native/app_launch_mode.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

class ShortPrivacyPolicyDialog extends StatefulWidget {
  const ShortPrivacyPolicyDialog({super.key});

  @override
  State<ShortPrivacyPolicyDialog> createState() => _ShortPrivacyPolicyDialogState();
}

class _ShortPrivacyPolicyDialogState extends State<ShortPrivacyPolicyDialog> {
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

    return CustomDialog(
      title: '',
      backgroundColor: AppColors.body2.withValues(alpha: 0.5),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text.rich(
          TextSpan(
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.body3,
              height: 1.25,
            ),
            children: <InlineSpan>[
              const TextSpan(
                text:
                    'Your data does not leave this device. '
                    'Snggle works offline and does not use external services to store or sync your data online. '
                    'Camera is only used for actions you control, such as QR scanning. '
                    'You can read the full ',
              ),
              TextSpan(
                text: 'Privacy Policy',
                style: textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.underline,
                  height: 1.25,
                ),
                recognizer: privacyPolicyTapGestureRecognizer,
              ),
              const TextSpan(
                text: ' for more information.',
              ),
            ],
          ),
          textAlign: TextAlign.justify,
        ),
      ),
      options: <CustomDialogOption>[
        CustomDialogOption(
          label: 'Consent',
          autoCloseBool: false,
          onPressed: () => AutoRouter.of(context).replace(
            AppMasterKeyRemovedRoute(
              appLaunchMode: AppLaunchMode.main,
            ),
          ),
        ),
      ],
    );
  }
}
