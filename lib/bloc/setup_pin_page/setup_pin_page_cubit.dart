import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_confirm_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_fail_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_init_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_setup_later.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_success_state.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/hash_mnemonic_service.dart';
import 'package:snuggle/shared/utils/app_logger.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_controller.dart';

part 'a_setup_pin_page_state.dart';

class SetupPinPageCubit extends Cubit<ASetupPinPageState> {
  String setupPin = '';
  final PinpadController setupPinpadController;
  final PinpadController confirmPinpadController;
  final HashMnemonicService _hashMnemonicService = globalLocator<HashMnemonicService>();

  SetupPinPageCubit({
    required this.setupPinpadController,
    required this.confirmPinpadController,
  }) : super(SetupPinPageInitState());

  Future<void> cancelConfirmState() async {
    emit(SetupPinPageInitState());
    confirmPinpadController.clear();
    setupPinpadController.clear();
  }

  Future<void> setupUpLater() async {
    try {
      // await _commonsRepository.setInitialSetupVisible(value: false).whenComplete(() => emit(SetupPinPageLaterState()));
      await _hashMnemonicService.storeAuthentication(pin: '0000').whenComplete(() => emit(SetupPinPageLaterState()));
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(SetupPinPageFailState());
    }
  }

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

  Future<void> _comparePin(String pin) async {
    if (setupPin == pin) {
      try {
        await _hashMnemonicService.storeAuthentication(pin: pin).whenComplete(() => emit(SetupPinPageSuccessState()));
      } catch (e) {
        AppLogger().log(message: e.toString());
        emit(SetupPinPageFailState());
      }
    } else {
      emit(SetupPinPageFailState());
    }
  }

  Future<void> _setSetupPin(String pin) async {
    setupPin = pin;

    emit(SetupPinPageConfirmState());
  }
}
