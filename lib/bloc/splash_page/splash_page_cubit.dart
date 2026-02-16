import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_enter_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_master_key_removed_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';

part 'a_splash_page_state.dart';

class SplashPageCubit extends Cubit<ASplashPageState> {
  final MasterKeyService _masterKeyService = globalLocator<MasterKeyService>();
  final AppService _appService = globalLocator<AppService>();

  SplashPageCubit() : super(SplashPageLoadingState());

  Future<void> init() async {
    try {
      bool masterKeyExistsBool = await _masterKeyService.isMasterKeyExists();
      bool databaseExistsBool = await _appService.isDataBaseExist();
      if (masterKeyExistsBool) {
        emit(SplashPageEnterPinState());
      } else {
        // TODO(Olga): Temporary solution until MasterKey recovery is implemented
        if (databaseExistsBool) {
          emit(SplashPageMasterKeyRemovedState());
        } else {
          emit(SplashPageSetupPinState());
        }
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(SplashPageErrorState());
    }
  }
}
