import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/a_secrets_auth_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/secrets_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class SecretsAuthPage extends StatefulWidget {
  final String title;
  final AListItemModel listItemModel;
  final ValueChanged<PasswordModel> passwordValidCallback;

  const SecretsAuthPage({
    required this.title,
    required this.listItemModel,
    required this.passwordValidCallback,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SecretsAuthPageState();
}

class _SecretsAuthPageState extends State<SecretsAuthPage> {
  late final SecretsAuthPageCubit secretsAuthPageCubit = SecretsAuthPageCubit(
    listItemModel: widget.listItemModel,
    passwordValidCallback: _handleValidPasswordEntered,
  );

  @override
  void dispose() {
    secretsAuthPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecretsAuthPageCubit, ASecretsAuthPageState>(
      bloc: secretsAuthPageCubit,
      builder: (BuildContext context, ASecretsAuthPageState secretsAuthPageState) {
        return PinpadScaffold(
          errorBool: secretsAuthPageState is SecretsAuthPageInvalidPinState,
          title: widget.title,
          initialPinNumbers: secretsAuthPageState.pinNumbers,
          onChanged: secretsAuthPageCubit.updatePinNumbers,
          actionButtons: <Widget>[
            CustomTextButton(
              title: 'Confirm',
              onPressed: secretsAuthPageCubit.authenticate,
            ),
          ],
        );
      },
    );
  }

  void _handleValidPasswordEntered(PasswordModel passwordModel) {
    Navigator.of(context).pop();
    widget.passwordValidCallback(passwordModel);
  }
}
