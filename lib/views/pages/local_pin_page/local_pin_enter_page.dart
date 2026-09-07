import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_enter_page/a_local_pin_enter_page_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_enter_page/local_pin_enter_page_cubit.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_enter_page/states/local_pin_enter_page_invalid_state.dart';
import 'package:snggle/infra/exceptions/invalid_master_key_exception.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/custom/dialog/master_key_dialog.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class LocalPinEnterPage extends StatefulWidget {
  final String title;
  final AListItemModel listItemModel;
  final Future<void> Function(PasswordModel passwordModel) passwordValidCallback;

  const LocalPinEnterPage({
    required this.title,
    required this.listItemModel,
    required this.passwordValidCallback,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LocalPinEnterPageState();
}

class _LocalPinEnterPageState extends State<LocalPinEnterPage> {
  late final LocalPinEnterPageCubit localPinEnterPageCubit = LocalPinEnterPageCubit(
    listItemModel: widget.listItemModel,
    passwordValidCallback: _handleValidPasswordEntered,
  );

  @override
  void dispose() {
    localPinEnterPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalPinEnterPageCubit, ALocalPinEnterPageState>(
      bloc: localPinEnterPageCubit,
      builder: (BuildContext context, ALocalPinEnterPageState localPinEnterPageState) {
        return PinpadScaffold(
          errorBool: localPinEnterPageState is LocalPinEnterPageInvalidState,
          title: widget.title,
          initialPinNumbersList: localPinEnterPageState.pinNumbers,
          onChanged: localPinEnterPageCubit.updatePinNumbers,
          actionButtonsList: <Widget>[
            CustomTextButton(
              title: 'Confirm',
              onPressed: () async {
                try {
                  await localPinEnterPageCubit.authenticate();
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
