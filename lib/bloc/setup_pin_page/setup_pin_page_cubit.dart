import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_confirm_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_fail_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_init_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_later_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_success_state.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/authentication_service.dart';
import 'package:snuggle/infra/services/settings_service.dart';
import 'package:snuggle/shared/models/mnemonic_model.dart';
import 'package:snuggle/shared/utils/app_logger.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_controller.dart';

part 'a_setup_pin_page_state.dart';

class SetupPinPageCubit extends Cubit<ASetupPinPageState> {
  final PinpadController setupPinpadController;
  final PinpadController confirmPinpadController;
  final AuthenticationService _authenticationService = globalLocator<AuthenticationService>();
  final SettingsService _settingsService = globalLocator<SettingsService>();

  String _setupPin = '';
  
  SetupPinPageCubit({
    required this.setupPinpadController,
    required this.confirmPinpadController,
  }) : super(SetupPinPageInitState());

  Future<void> cancelConfirmState() async {
    confirmPinpadController.clear();
    setupPinpadController.clear();
    emit(SetupPinPageInitState());
  }

  Future<void> setupLater() async {
    try {
      await _settingsService.setSetupPinVisible(value: false).whenComplete(() => emit(SetupPinPageLaterState()));
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
    if (_setupPin == pin) {
      try {
        MnemonicModel mnemonicModel = MnemonicModel.generate();
        await _authenticationService.setupPrivateKey(mnemonicModel: mnemonicModel, pin: pin);
        await _settingsService.setSetupPinVisible(value: false);
        emit(SetupPinPageSuccessState());
      } catch (e) {
        AppLogger().log(message: e.toString());
        emit(SetupPinPageFailState());
      }
    } else {
      emit(SetupPinPageFailState());
    }
  }

  Future<void> _setSetupPin(String pin) async {
    _setupPin = pin;

    emit(SetupPinPageConfirmState());
  }
}
