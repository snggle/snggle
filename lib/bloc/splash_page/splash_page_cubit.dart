import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_enter_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_ignore_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_auth_service.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

part 'a_splash_page_state.dart';

class SplashPageCubit extends Cubit<ASplashPageState> {
  final AppAuthService _appAuthService = globalLocator<AppAuthService>();
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();
  final AuthSingletonCubit _authSingletonCubit = globalLocator<AuthSingletonCubit>();

  SplashPageCubit() : super(SplashPageLoadingState());

  Future<void> init() async {
    try {
      bool masterKeyExistsBool = await _masterKeyService.isMasterKeyExists();
      bool appCustomPasswordSetBool = await _appAuthService.isCustomPasswordSet();

      // TODO(dominik): Temporary delay to ensure that the splash screen is visible when opening the app. Created for presentation purposes.
      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (masterKeyExistsBool == false) {
        emit(SplashPageSetupPinState());
      } else if (appCustomPasswordSetBool) {
        emit(SplashPageEnterPinState());
      } else {
        await _authenticateWithDefaultPassword();
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(SplashPageErrorState());
    }
  }

  Future<void> _authenticateWithDefaultPassword() async {
    _authSingletonCubit.setAppPassword(PasswordModel.defaultPassword());
    emit(SplashPageIgnorePinState());
  }
}
