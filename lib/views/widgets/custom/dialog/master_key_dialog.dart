import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

class MasterKeyDialog extends StatelessWidget {
  const MasterKeyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return CustomDialog(
      title: 'INVALID MASTER KEY',
      backgroundColor: Colors.white,
      borderGradient: AppColors.warningRedGradient,
      titleContentSpacing: 10,
      contentOptionsSpacing: 8,
      content: Text(
        'This data was encrypted with a different Master Key.',
        style: textTheme.labelMedium,
        textAlign: TextAlign.center,
      ),
      options: <CustomDialogOption>[
        CustomDialogOption(
          label: 'Close',
          onPressed: () {},
        ),
      ],
    );
  }

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return const MasterKeyDialog();
      },
    );
  }
}
