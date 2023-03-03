import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_enter_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_ignore_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/config/app_config.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/auth_service.dart';
import 'package:snggle/infra/services/settings_service.dart';
import 'package:snggle/shared/models/salt_model.dart';
import 'package:snggle/shared/utils/app_logger.dart';

part 'a_splash_page_state.dart';

class SplashPageCubit extends Cubit<ASplashPageState> {
  SplashPageCubit() : super(SplashPageLoadingState());

  final AuthService _authService = globalLocator<AuthService>();
  final SettingsService _settingsService = globalLocator<SettingsService>();

  Future<void> init() async {
    try {
      bool isSetupPinPage = await _settingsService.isSetupPinVisible();
      bool isAuthPage = await _authService.isAppPasswordExist();
      bool isSaltExistBool = await _authService.isSaltExist();

      if (isSetupPinPage) {
        emit(SplashPageSetupPinState());
      } else if (isAuthPage) {
        emit(SplashPageEnterPinState());
      } else if (isSaltExistBool) {
        emit(SplashPageIgnorePinState());
      } else {
        SaltModel saltModel = await SaltModel.generateSalt(hashedPassword: AppConfig.defaultPassword, isDefaultPassword: true);
        await _settingsService.setSetupPinVisible(value: true);
        await _authService.setSaltModel(saltModel: saltModel);
        emit(SplashPageIgnorePinState());
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(SplashPageErrorState());
    }
  }
}
