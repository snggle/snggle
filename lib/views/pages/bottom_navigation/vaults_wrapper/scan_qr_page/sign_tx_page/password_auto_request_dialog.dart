import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/sign_tx_page_cubit.dart';
import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/states/sign_tx_page_enter_passwords_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/bottom_navigation/secrets_auth_page.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

class PasswordAutoRequestDialog extends StatefulWidget {
  final SignTxPageCubit signTxPageCubit;
  final SignTxPageEnterPasswordsState signTxPageFillPasswordsState;

  const PasswordAutoRequestDialog({
    required this.signTxPageCubit,
    required this.signTxPageFillPasswordsState,
    super.key,
  });

  @override
  State<PasswordAutoRequestDialog> createState() => _PasswordAutoRequestDialogState();
}

class _PasswordAutoRequestDialogState extends State<PasswordAutoRequestDialog> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: '${widget.signTxPageFillPasswordsState.listItemModels[index].name} is locked',
      content: const Text('Provide password for this element to continue with the transaction.'),
      options: <CustomDialogOption>[
        CustomDialogOption(
          label: 'Cancel',
          onPressed: () {
            for (int i = index - 1; i >= 0; i--) {
              globalLocator<PasswordController>().removeByFilesystemPath(widget.signTxPageFillPasswordsState.listItemModels[i].filesystemPath);
            }
          },
        ),
        CustomDialogOption(
          autoCloseBool: false,
          label: 'Continue',
          onPressed: () {
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) => SecretsAuthPage(
                title: 'ENTER PIN',
                subtitle: 'for ${widget.signTxPageFillPasswordsState.listItemModels[index].name}',
                listItemModel: widget.signTxPageFillPasswordsState.listItemModels[index],
                passwordValidCallback: (PasswordModel passwordModel) {
                  globalLocator<PasswordController>().addPassword(passwordModel, widget.signTxPageFillPasswordsState.listItemModels[index].filesystemPath);

                  if (index < widget.signTxPageFillPasswordsState.listItemModels.length - 1) {
                    setState(() {
                      index++;
                    });
                  } else {
                    widget.signTxPageCubit.accept();
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
