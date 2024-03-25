import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/a_secrets_auth_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_remove_pin_page/secrets_remove_pin_page_cubit.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class SecretsRemovePinPage extends StatefulWidget {
  final AContainerModel containerModel;

  const SecretsRemovePinPage({
    required this.containerModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SecretsRemovePinPageState();
}

class _SecretsRemovePinPageState extends State<SecretsRemovePinPage> {
  late final SecretsRemovePinPagePageCubit secretsRemovePinPagePageCubit = SecretsRemovePinPagePageCubit(containerModel: widget.containerModel);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecretsRemovePinPagePageCubit, ASecretsAuthPageState>(
      bloc: secretsRemovePinPagePageCubit,
      builder: (BuildContext context, ASecretsAuthPageState secretsAuthPageState) {
        return PinpadScaffold(
          errorBool: secretsAuthPageState is SecretsAuthPageInvalidPinState,
          title: 'REMOVE PIN',
          initialPinNumbers: secretsAuthPageState.pinNumbers,
          onChanged: secretsRemovePinPagePageCubit.updatePinNumbers,
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
    try {
      await secretsRemovePinPagePageCubit.authenticate();
      Navigator.of(context).pop(true);
    } catch (e) {
      AppLogger().log(message: 'Provided invalid PIN');
    }
  }
}
