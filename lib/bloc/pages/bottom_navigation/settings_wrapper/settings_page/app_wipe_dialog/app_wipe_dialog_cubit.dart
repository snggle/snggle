import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/app_wipe_dialog/app_wipe_dialog_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_service.dart';

class AppWipeDialogCubit extends Cubit<AppWipeDialogState> {
  final AppService _appService = globalLocator<AppService>();

  final VoidCallback _applicationWipedCallback;

  AppWipeDialogCubit({
    required void Function() applicationWipedCallback,
  })  : _applicationWipedCallback = applicationWipedCallback,
        super(const AppWipeDialogState(confirmationsCount: 0));

  Future<void> confirm() async {
    if (state.confirmationsCount < AppWipeDialogState.requiredConfirmationsCount) {
      emit(state.copyWith(confirmationsCount: state.confirmationsCount + 1));
    } else {
      emit(state.copyWith(wipeInProgressBool: true));

      await _appService.wipeAll();
      _applicationWipedCallback();
    }
  }
}
