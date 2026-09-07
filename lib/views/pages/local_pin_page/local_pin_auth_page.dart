import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/a_local_pin_auth_page_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/local_pin_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_auth_page/states/local_pin_auth_page_invalid_state.dart';
import 'package:snggle/infra/exceptions/invalid_master_key_exception.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/custom/dialog/master_key_dialog.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class LocalPinAuthPage extends StatefulWidget {
  final String title;
  final AListItemModel listItemModel;
  final Future<void> Function(PasswordModel passwordModel) passwordValidCallback;

  const LocalPinAuthPage({
    required this.title,
    required this.listItemModel,
    required this.passwordValidCallback,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LocalPinAuthPageState();
}

class _LocalPinAuthPageState extends State<LocalPinAuthPage> {
  late final LocalPinAuthPageCubit localPinAuthPageCubit = LocalPinAuthPageCubit(
    listItemModel: widget.listItemModel,
    passwordValidCallback: _handleValidPasswordEntered,
  );

  @override
  void dispose() {
    localPinAuthPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalPinAuthPageCubit, ALocalPinAuthPageState>(
      bloc: localPinAuthPageCubit,
      builder: (BuildContext context, ALocalPinAuthPageState localPinAuthPageState) {
        return PinpadScaffold(
          errorBool: localPinAuthPageState is LocalPinAuthPageInvalidState,
          title: widget.title,
          initialPinNumbersList: localPinAuthPageState.pinNumbers,
          onChanged: localPinAuthPageCubit.updatePinNumbers,
          actionButtonsList: <Widget>[
            CustomTextButton(
              title: 'Confirm',
              onPressed: () async {
                try {
                  await localPinAuthPageCubit.authenticate();
                } on InvalidMasterKeyException {
                  if (mounted == false) {
                    return;
                  }
                  await MasterKeyDialog.show(context);
                }
              },
            ),
          ],
          popButtonVisibleBool: true,
        );
      },
    );
  }

  Future<void> _handleValidPasswordEntered(PasswordModel passwordModel) async {
    Navigator.of(context).pop();
    await widget.passwordValidCallback(passwordModel);
  }
}
