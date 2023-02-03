import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_ignore_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/settings_service.dart';
import 'package:snggle/shared/utils/app_logger.dart';

part 'a_splash_page_state.dart';

class SplashPageCubit extends Cubit<ASplashPageState> {
  SplashPageCubit() : super(SplashPageLoadingState());

  final SettingsService _settingsService = globalLocator<SettingsService>();

  Future<void> init() async {
    try {
      bool setupPinVisibleBool = await _settingsService.isSetupPinVisible();
      if (setupPinVisibleBool) {
        emit(SplashPageSetupPinState());
      } else {
        emit(SplashPageIgnorePinState());
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(SplashPageErrorState());
    }
  }
}
