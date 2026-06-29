import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

class VaultDiscardDialog extends StatelessWidget {
  final VoidCallback onDiscardPressed;

  const VaultDiscardDialog({
    required this.onDiscardPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Discard the vault?',
      content: const Text(
        'You will lose all data\n'
        'related to this vault.',
        textAlign: TextAlign.center,
      ),
      options: <CustomDialogOption>[
        CustomDialogOption(
          label: 'Cancel',
          onPressed: () {},
        ),
        CustomDialogOption(
          label: 'Discard',
          onPressed: onDiscardPressed,
        ),
      ],
    );
  }
}
