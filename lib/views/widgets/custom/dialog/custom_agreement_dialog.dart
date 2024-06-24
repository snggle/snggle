import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

class CustomAgreementDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onConfirm;
  final VoidCallback? onReject;

  const CustomAgreementDialog({
    required this.title,
    required this.content,
    this.onConfirm,
    this.onReject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return CustomDialog(
      title: title,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium!.copyWith(color: AppColors.body3),
        ),
      ),
      options: <CustomDialogOption>[
        CustomDialogOption(
          label: 'No',
          onPressed: onReject ?? () {},
        ),
        CustomDialogOption(
          label: 'Yes',
          onPressed: onConfirm ?? () {},
        ),
      ],
    );
  }
}
