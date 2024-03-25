import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/shared/models/password_model.dart';

class SecretsSetupPinPageCubit extends Cubit<ASecretsSetupPinPageState> {
  final ValueChanged<PasswordModel> passwordValidCallback;

  SecretsSetupPinPageCubit({
    required this.passwordValidCallback,
  }) : super(const SecretsSetupPinPageEnterPinState.empty());

  void updateFirstPin(List<int> firstPinNumbers) {
    emit(SecretsSetupPinPageEnterPinState(firstPinNumbers: firstPinNumbers));
  }

  void updateConfirmPin(List<int> confirmPinNumbers) {
    assert(state is SecretsSetupPinPageConfirmPinState, 'State must be [SecretsSetupPinPageConfirmPinState] to call this method');

    SecretsSetupPinPageConfirmPinState secretsSetupPinPageConfirmPinState = state as SecretsSetupPinPageConfirmPinState;
    emit(secretsSetupPinPageConfirmPinState.copyWith(confirmPinNumbers: confirmPinNumbers));
  }

  void setupFirstPin() {
    SecretsSetupPinPageEnterPinState secretsSetupPinPageEnterPinState = state as SecretsSetupPinPageEnterPinState;
    emit(SecretsSetupPinPageConfirmPinState(
      firstPinNumbers: secretsSetupPinPageEnterPinState.firstPinNumbers,
      confirmPinNumbers: const <int>[],
    ));
  }

  Future<void> setupConfirmPin() async {
    assert(state is SecretsSetupPinPageConfirmPinState, 'State must be [SecretsSetupPinPageConfirmPinState] to call this method');
    SecretsSetupPinPageConfirmPinState secretsSetupPinPageConfirmPinState = state as SecretsSetupPinPageConfirmPinState;

    if (secretsSetupPinPageConfirmPinState.arePasswordsEqual()) {
      List<int> firstPinNumbers = secretsSetupPinPageConfirmPinState.firstPinNumbers;
      PasswordModel passwordModel = PasswordModel.fromPlaintext(firstPinNumbers.join(''));
      passwordValidCallback(passwordModel);
    } else {
      emit(SecretsSetupPinPageInvalidPinState(
        firstPinNumbers: secretsSetupPinPageConfirmPinState.firstPinNumbers,
        confirmPinNumbers: secretsSetupPinPageConfirmPinState.confirmPinNumbers,
      ));
    }
  }

  void resetAllPins() {
    emit(const SecretsSetupPinPageEnterPinState.empty());
  }
}
