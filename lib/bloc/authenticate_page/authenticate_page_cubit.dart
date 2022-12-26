import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_error_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_initial_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_invalid_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_load_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_success_state.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/authenticate_service.dart';
import 'package:snuggle/shared/utils/app_logger.dart';

part 'a_authenticate_page_state.dart';

class AuthenticatePageCubit extends Cubit<AAuthenticatePageState> {
  AuthenticatePageCubit() : super(AuthenticatePageInitialState());

  final AuthenticateService _authenticateService = globalLocator<AuthenticateService>();

  Future<void> verifyAuthentication({required String pin}) async {
    emit(AuthenticatePageLoadState());
    try {
      bool isAuthenticationValid = await _authenticateService.verifyAuthentication(pin: pin);
      if (isAuthenticationValid) {
        emit(AuthenticatePageSuccessState());
      } else {
        emit(AuthenticatePageInvalidState());
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(AuthenticatePageErrorState());
    }
  }
}
