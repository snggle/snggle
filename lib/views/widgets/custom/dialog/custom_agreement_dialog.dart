import 'package:flutter/material.dart';
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
    return CustomDialog(
      title: title,
      content: content,
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
