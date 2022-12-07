import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/infra/services/authentication/auth_service.dart';

part 'a_auth_page_state.dart';

class AuthPageCubit extends Cubit<AAuthPageState> {
  AuthPageCubit() : super(AuthPageInitialState());

  Future<void> isAuthenticationSetup() async {
    try {
      bool isAuthenticationSetup = await AuthService.isAuthenticationSetup();
      if (isAuthenticationSetup) {
        bool isAuthenticated = await AuthService.isAuthenticated();
        isAuthenticated ? emit(AuthPageAuthenticateState()) : emit(AuthPageNoAuthenticationState());
      } else {
        emit(AuthPageSetupAuthenticationState());
      }
    } catch (e) {
      emit(AuthPageErrorAuthenticationState());
    }
  }

  Future<void> verifyAuthentication(String pin) async {
    emit(AuthPageLoadingAuthenticationState());
    bool isAuthenticationValid = await AuthService.verifyAuthentication(pin: pin);
    if (isAuthenticationValid) {
      emit(AuthPageSuccessAuthenticationState());
    } else {
      emit(AuthPageInvalidAuthenticationState());
    }
  }
}
