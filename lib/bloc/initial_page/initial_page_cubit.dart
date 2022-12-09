import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/authentication/auth_service.dart';
import 'package:snuggle/shared/utils/app_logger.dart';

part 'a_initial_page_state.dart';

class InitialPageCubit extends Cubit<AInitialPageState> {
  InitialPageCubit() : super(InitialPageInitialState());

  final AuthService _authService = globalLocator<AuthService>();

  Future<void> isAuthenticationSetup() async {
    try {
      bool isAuthenticationSetup = await _authService.isAuthenticationSetup();
      if (isAuthenticationSetup) {
        bool isAuthenticated = await _authService.isAuthenticated();
        isAuthenticated ? emit(InitialPageAuthenticateState()) : emit(InitialPageNoAuthenticationState());
      } else {
        emit(InitialPageSetupAuthenticationState());
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(InitialPageErrorState());
    }
  }
}
