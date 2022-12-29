import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_error_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_initial_setup_visible_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_initial_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_skip_authentication_state.dart';
import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/services/initial_service.dart';
import 'package:snuggle/shared/utils/app_logger.dart';

part 'a_initial_page_state.dart';

class InitialPageCubit extends Cubit<AInitialPageState> {
  InitialPageCubit() : super(InitialPageInitialState());

  final InitialService _initialService = globalLocator<InitialService>();

  Future<void> checkInitialSetupVisibleState() async {
    try {
      bool isInitialSetup = await _initialService.checkInitialVisibleSetup();
      if (isInitialSetup) {
        emit(InitialPageInitialSetupVisibleState());
      } else {
        emit(InitialPageSkipAuthenticationState());
      }
    } catch (e) {
      AppLogger().log(message: e.toString());
      emit(InitialPageErrorState());
    }
  }
}
