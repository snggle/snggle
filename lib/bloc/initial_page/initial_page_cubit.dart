import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/infra/services/authentication/auth_service.dart';
import 'package:snuggle/shared/utils/app_logger.dart';

part 'a_initial_page_state.dart';

class InitialPageCubit extends Cubit<AInitialPageState> {
  InitialPageCubit() : super(InitialPageInitialState());

  Future<void> isAuthenticationSetup() async {
    try {
      bool isAuthenticationSetup = await AuthService().isAuthenticationSetup();
      if (isAuthenticationSetup) {
        bool isAuthenticated = await AuthService().isAuthenticated();
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
