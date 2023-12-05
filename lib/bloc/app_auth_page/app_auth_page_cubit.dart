import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_error_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_initial_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_invalid_password_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_load_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_success_state.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_auth_service.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/app_logger.dart';

part 'a_app_auth_page_state.dart';

class AppAuthPageCubit extends Cubit<AAppAuthPageState> {
  final AuthSingletonCubit _authSingletonCubit = globalLocator<AuthSingletonCubit>();
  final AppAuthService _appAuthService = globalLocator<AppAuthService>();

  AppAuthPageCubit() : super(AppAuthPageInitialState());

  Future<void> authenticate({required PasswordModel passwordModel}) async {
    emit(AppAuthPageLoadState());
    try {
      bool passwordValidBool = await _appAuthService.isPasswordValid(passwordModel);
      if (passwordValidBool) {
        _authSingletonCubit.setAppPassword(passwordModel);
        emit(AppAuthPageSuccessState());
      } else {
        emit(AppAuthPageInvalidPasswordState());
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(AppAuthPageErrorState());
    }
  }
}
