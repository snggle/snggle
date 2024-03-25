import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/a_secrets_auth_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/secrets_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/models/password_entry_result_model.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class SecretsAuthPagePage extends StatefulWidget {
  final AContainerModel containerModel;

  const SecretsAuthPagePage({
    required this.containerModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SecretsAuthPagePageState();
}

class _SecretsAuthPagePageState extends State<SecretsAuthPagePage> {
  late final SecretsAuthPageCubit secretsAuthPageCubit = SecretsAuthPageCubit(containerModel: widget.containerModel);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecretsAuthPageCubit, ASecretsAuthPageState>(
      bloc: secretsAuthPageCubit,
      builder: (BuildContext context, ASecretsAuthPageState secretsAuthPageState) {
        return PinpadScaffold(
          errorBool: secretsAuthPageState is SecretsAuthPageInvalidPinState,
          title: 'ENTRY PIN',
          initialPinNumbers: secretsAuthPageState.pinNumbers,
          onChanged: secretsAuthPageCubit.updatePinNumbers,
          actionButtons: <Widget>[
            CustomTextButton(
              title: 'Authorize',
              onPressed: _handleAuthorizeButtonPressed,
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleAuthorizeButtonPressed() async {
    PasswordEntryResultModel passwordEntryResultModel = await secretsAuthPageCubit.authenticate();
    Navigator.of(context).pop(passwordEntryResultModel);
  }
}
