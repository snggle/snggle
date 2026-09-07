import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/a_local_pin_set_up_page_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_confirm_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_enter_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_invalid_state.dart';
import 'package:snggle/shared/models/password_model.dart';

class LocalPinSetUpPageCubit extends Cubit<ALocalPinSetUpPageState> {
  final ValueChanged<PasswordModel> passwordValidCallback;

  LocalPinSetUpPageCubit({
    required this.passwordValidCallback,
  }) : super(const LocalPinSetUpPageEnterState.empty());

  void updateFirstPin(List<int> firstPinNumbers) {
    emit(LocalPinSetUpPageEnterState(firstPinNumbers: firstPinNumbers));
  }

  void updateConfirmPin(List<int> confirmPinNumbers) {
    assert(state is LocalPinSetUpPageConfirmState, 'State must be [LocalPinSetUpPageConfirmState] to call this method');

    LocalPinSetUpPageConfirmState localPinSetUpPageConfirmState = state as LocalPinSetUpPageConfirmState;
    emit(localPinSetUpPageConfirmState.copyWith(confirmPinNumbers: confirmPinNumbers));
  }

  void setupFirstPin() {
    LocalPinSetUpPageEnterState localPinSetUpPageEnterState = state as LocalPinSetUpPageEnterState;
    emit(LocalPinSetUpPageConfirmState(
      firstPinNumbers: localPinSetUpPageEnterState.firstPinNumbers,
      confirmPinNumbers: const <int>[],
    ));
  }

  Future<void> setupConfirmPin() async {
    assert(state is LocalPinSetUpPageConfirmState, 'State must be [LocalPinSetUpPageConfirmState] to call this method');
    LocalPinSetUpPageConfirmState localPinSetUpPageConfirmState = state as LocalPinSetUpPageConfirmState;

    if (localPinSetUpPageConfirmState.arePasswordsEqual()) {
      List<int> firstPinNumbers = localPinSetUpPageConfirmState.firstPinNumbers;
      PasswordModel passwordModel = PasswordModel.fromPlaintext(firstPinNumbers.join(''));
      passwordValidCallback(passwordModel);
    } else {
      emit(LocalPinSetUpPageInvalidState(
        firstPinNumbers: localPinSetUpPageConfirmState.firstPinNumbers,
        confirmPinNumbers: localPinSetUpPageConfirmState.confirmPinNumbers,
      ));
    }
  }

  void resetAllPins() {
    emit(const LocalPinSetUpPageEnterState.empty());
  }
}
