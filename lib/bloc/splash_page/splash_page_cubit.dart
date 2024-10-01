import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_enter_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_ignore_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

part 'a_splash_page_state.dart';

class SplashPageCubit extends Cubit<ASplashPageState> {
  final AppService _appService = globalLocator<AppService>();
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();
  final MasterKeyController _masterKeyController = globalLocator<MasterKeyController>();

  SplashPageCubit() : super(SplashPageLoadingState());

  Future<void> init() async {
    try {
      bool masterKeyExistsBool = await _masterKeyService.isMasterKeyExists();
      bool appCustomPasswordSetBool = await _appService.isCustomPasswordSet();

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
    _masterKeyController.setPassword(PasswordModel.defaultPassword());
    emit(SplashPageIgnorePinState());
  }
}
