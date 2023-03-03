import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_error_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_initial_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_invalid_password_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_load_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_success_state.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/auth_service.dart';
import 'package:snggle/shared/utils/app_logger.dart';

part 'a_app_auth_page_state.dart';

class AppAuthPageCubit extends Cubit<AAppAuthPageState> {
  final AuthSingletonCubit authSingletonCubit = globalLocator<AuthSingletonCubit>();
  final AuthService authService = globalLocator<AuthService>();

  AppAuthPageCubit() : super(AppAuthPageInitialState());

  Future<void> authenticate({required String password}) async {
    emit(AppAuthPageLoadState());
    try {
      List<int> passwordBytes = utf8.encode(password);
      String hashedPassword = sha256.convert(passwordBytes).toString();
      bool isAuthenticationValid = await authService.isAppPasswordValid(hashedPassword: hashedPassword);
      if (isAuthenticationValid) {
        authSingletonCubit.setPassword(hashedPassword);
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
