import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/infra/services/authentication/auth_service.dart';
import 'package:snuggle/shared/utils/app_logger.dart';

part 'a_auth_page_state.dart';

class AuthPageCubit extends Cubit<AAuthPageState> {
  AuthPageCubit() : super(AuthPageInitialState());

  Future<void> verifyAuthentication(String pin) async {
    emit(AuthPageLoadingAuthenticationState());
    try {
      bool isAuthenticationValid = await AuthService().verifyAuthentication(pin: pin);
      if (isAuthenticationValid) {
        emit(AuthPageSuccessAuthenticationState());
      } else {
        emit(AuthPageInvalidAuthenticationState());
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(AuthPageErrorState());
    }
  }
}
