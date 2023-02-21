import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_confirm_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_fail_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_init_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_setup_later_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_success_state.dart';
import 'package:snggle/config/app_config.dart';

import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/authentication_service.dart';
import 'package:snggle/infra/services/settings_service.dart';
import 'package:snggle/shared/models/salt_model.dart';
import 'package:snggle/shared/utils/app_logger.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_controller.dart';

part 'a_app_setup_pin_page_state.dart';

class AppSetupPinPageCubit extends Cubit<AAppSetupPinPageState> {
  final PinpadController setupPinpadController;
  final PinpadController confirmPinpadController;
  final AuthenticationService _authenticationService = globalLocator<AuthenticationService>();
  final SettingsService _settingsService = globalLocator<SettingsService>();

  String _setupPin = '';

  AppSetupPinPageCubit({
    required this.setupPinpadController,
    required this.confirmPinpadController,
  }) : super(AppSetupPinPageInitState());

  Future<void> cancelConfirmState() async {
    confirmPinpadController.clear();
    setupPinpadController.clear();
    emit(AppSetupPinPageInitState());
  }

  Future<void> setupLater() async {
    try {
      SaltModel saltModel = await SaltModel.generateSalt(password: AppConfig.defaultPassword, isDefaultPassword: true);
      await _settingsService.setSetupPinVisible(value: false);
      await _authenticationService.setSaltModel(saltModel: saltModel);
      emit(AppSetupPinPageSetupLaterState());
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(AppSetupPinPageFailState());
    }
  }

  Future<void> updateState() async {
    if (state is AppSetupPinPageInitState) {
      String pin = setupPinpadController.value;
      if (pin.length == setupPinpadController.pinpadTextFieldsSize) {
        await _setSetupPin(pin);
      }
    } else if (state is AppSetupPinPageConfirmState || state is AppSetupPinPageFailState) {
      String confirmPin = confirmPinpadController.value;
      if (confirmPin.length == confirmPinpadController.pinpadTextFieldsSize) {
        await _comparePin(confirmPin);
      }
    }
  }

  Future<void> _comparePin(String pin) async {
    if (_setupPin == pin) {
      try {
        SaltModel saltModel = await SaltModel.generateSalt(password: pin, isDefaultPassword: false);
        await _settingsService.setSetupPinVisible(value: false);
        await _authenticationService.setSaltModel(saltModel: saltModel);
        emit(AppSetupPinPageSuccessState());
      } catch (e) {
        AppLogger().log(message: e.toString());
        emit(AppSetupPinPageFailState());
      }
    } else {
      emit(AppSetupPinPageFailState());
    }
  }

  Future<void> _setSetupPin(String pin) async {
    _setupPin = pin;

    emit(AppSetupPinPageConfirmState());
  }
}
