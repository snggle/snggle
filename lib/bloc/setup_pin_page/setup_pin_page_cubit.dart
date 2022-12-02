import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_confirm_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_fail_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_init_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_success_state.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_controller.dart';

part 'a_setup_pin_page_state.dart';

class SetupPinPageCubit extends Cubit<ASetupPinPageState> {
  String setupPin = '';
  final PinpadController setupPinpadController;
  final PinpadController confirmPinpadController;

  SetupPinPageCubit({
    required this.setupPinpadController,
    required this.confirmPinpadController,
  }) : super(SetupPinPageInitState());

  Future<void> updateState() async {
    if (state is SetupPinPageInitState) {
      String pin = setupPinpadController.value;
      if (pin.length == setupPinpadController.pinpadTextFieldsSize) {
        await _setSetupPin(pin);
      }
    } else if (state is SetupPinPageConfirmState || state is SetupPinPageFailState) {
      String confirmPin = confirmPinpadController.value;
      if (confirmPin.length == confirmPinpadController.pinpadTextFieldsSize) {
        await _comparePin(confirmPin);
      }
    }
  }

  Future<void> cancelConfirmState() async {
    emit(SetupPinPageInitState());
    confirmPinpadController.clear();
    setupPinpadController.clear();
  }

  Future<void> _setSetupPin(String pin) async {
    setupPin = pin;
    emit(SetupPinPageConfirmState());
  }

  Future<void> _comparePin(String pin) async {
    if (setupPin == pin) {
      emit(SetupPinPageSuccessState());
    } else {
      emit(SetupPinPageFailState());
    }
  }
}
