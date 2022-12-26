import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_authentication_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_error_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_initial_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_setup_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_skip_authenticate_state.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/initial_service.dart';
import 'package:snuggle/shared/utils/app_logger.dart';

part 'a_initial_page_state.dart';

class InitialPageCubit extends Cubit<AInitialPageState> {
  InitialPageCubit() : super(InitialPageInitialState());

  final InitialService _authService = globalLocator<InitialService>();

  Future<void> checkSetup() async {
    try {
      bool isSetup = await InitialService().checkSetup();
      if (isSetup) {
        emit(InitialPageSetupState());
      } else {
        bool isAuthenticated = await _authService.isAuthenticated();
        isAuthenticated ? emit(InitialPageAuthenticationState()) : emit(InitialPageSkipAuthenticationState());
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(InitialPageErrorState());
    }
  }
}
