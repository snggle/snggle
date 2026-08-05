import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/secrets_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/infra/exceptions/invalid_master_key_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/custom/dialog/master_key_dialog.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class SecretsSetupPinPage extends StatefulWidget {
  final Future<void> Function(PasswordModel passwordModel) passwordValidCallback;

  const SecretsSetupPinPage({
    required this.passwordValidCallback,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SecretsSetupPinPageState();
}

class _SecretsSetupPinPageState extends State<SecretsSetupPinPage> {
  late final SecretsSetupPinPageCubit secretsSetupPinPageCubit = SecretsSetupPinPageCubit(
    passwordValidCallback: _handleValidPasswordEntered,
  );

  @override
  void dispose() {
    secretsSetupPinPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecretsSetupPinPageCubit, ASecretsSetupPinPageState>(
      bloc: secretsSetupPinPageCubit,
      builder: (BuildContext context, ASecretsSetupPinPageState secretsSetupPinPageState) {
        late Widget child;

        if (secretsSetupPinPageState is SecretsSetupPinPageEnterPinState) {
          child = PinpadScaffold(
            errorBool: false,
            title: 'Setup Access PIN',
            initialPinNumbersList: secretsSetupPinPageState.firstPinNumbers,
            onChanged: _handleFirstPinChange,
            actionButtonsList: <Widget>[
              if (secretsSetupPinPageState.firstPinNumbers.length >= 4)
                CustomTextButton(
                  title: 'Confirm',
                  onPressed: secretsSetupPinPageCubit.setupFirstPin,
                ),
            ],
            popButtonVisibleBool: false,
          );
        } else if (secretsSetupPinPageState is SecretsSetupPinPageConfirmPinState) {
          child = PinpadScaffold(
            maxPinLength: secretsSetupPinPageState.firstPinNumbers.length,
            errorBool: secretsSetupPinPageState is SecretsSetupPinPageInvalidPinState,
            title: 'Confirm PIN',
            initialPinNumbersList: secretsSetupPinPageState.confirmPinNumbers,
            onChanged: (List<int> confirmPinNumbers) => _handleConfirmPinChange(secretsSetupPinPageState.firstPinNumbers, confirmPinNumbers),
            actionButtonsList: <Widget>[
              if (secretsSetupPinPageState.confirmPinNumbers.isEmpty)
                CustomTextButton(
                  title: 'Return',
                  onPressed: secretsSetupPinPageCubit.resetAllPins,
                ),
            ],
            popButtonVisibleBool: true,
            customPopVoidCallback: _handleBackButtonPressed,
          );
        }

        return PopScope(
          canPop: (secretsSetupPinPageState is SecretsSetupPinPageConfirmPinState) == false,
          onPopInvokedWithResult: (bool didPop, _) {
            if (didPop) {
              return;
            }
            _handleBackButtonPressed();
          },
          child: Material(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleValidPasswordEntered(PasswordModel passwordModel) async {
    Navigator.of(context).pop();
    try {
      await widget.passwordValidCallback(passwordModel);
    } on InvalidMasterKeyException {
      if (mounted == false) {
        return;
      }
      await MasterKeyDialog.show(context);
    }
  }

  void _handleFirstPinChange(List<int> pinNumbersList) {
    secretsSetupPinPageCubit.updateFirstPin(pinNumbersList);
  }

  void _handleConfirmPinChange(List<int> firstPinNumbersList, List<int> confirmPinNumbersList) {
    secretsSetupPinPageCubit.updateConfirmPin(confirmPinNumbersList);
    if (firstPinNumbersList.length == confirmPinNumbersList.length) {
      secretsSetupPinPageCubit.setupConfirmPin();
    }
  }

  void _handleBackButtonPressed() {
    if (secretsSetupPinPageCubit.state is SecretsSetupPinPageConfirmPinState) {
      secretsSetupPinPageCubit.resetAllPins();
    }
  }
}
