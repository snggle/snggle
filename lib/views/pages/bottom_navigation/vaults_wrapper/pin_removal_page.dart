import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/secrets_auth_page/a_secrets_auth_page_state.dart';
import 'package:snggle/bloc/secrets_auth_page/states/secrets_auth_page_invalid_pin_state.dart';
import 'package:snggle/bloc/secrets_remove_pin_page/secrets_remove_pin_page_cubit.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class PinRemovalPage<T extends ASecretsModel> extends StatefulWidget {
  final VaultModel containerModel;

  const PinRemovalPage({
    required this.containerModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PinRemovalPageState<T>();
}

class _PinRemovalPageState<T extends ASecretsModel> extends State<PinRemovalPage<T>> {
  late final SecretsRemovePinPagePageCubit<T> secretsRemovePinPagePageCubit = SecretsRemovePinPagePageCubit<T>(containerModel: widget.containerModel);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecretsRemovePinPagePageCubit<T>, ASecretsAuthPageState>(
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
