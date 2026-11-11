import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/auto_logout_settings_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';

part 'auto_logout_state.dart';

class AutoLogoutCubit extends Cubit<AutoLogoutState> {
  final AutoLogoutSettingsService _autoLogoutSettingsService = globalLocator<AutoLogoutSettingsService>();

  AutoLogoutCubit()
    : super(
        const AutoLogoutState(
          inactivityLogoutEnabledBool: AutoLogoutSettingsModel.defaultInactivityLogoutBool,
          backgroundLogoutMode: AutoLogoutSettingsModel.defaultBackgroundLogoutMode,
          inactivityLogoutTimer: AutoLogoutSettingsModel.defaultInactivityLogoutTimer,
        ),
      );

  Future<void> init() async {
    AutoLogoutSettingsModel autoLogoutSettingsModel = await _autoLogoutSettingsService.getAutoLogoutSettings();
    emit(
      state.copyWith(
        inactivityLogoutEnabledBool: autoLogoutSettingsModel.inactivityLogoutBool,
        backgroundLogoutMode: autoLogoutSettingsModel.backgroundLogoutMode,
        inactivityLogoutTimer: autoLogoutSettingsModel.inactivityLogoutTimer,
      ),
    );
  }

  Future<void> setBackgroundLogoutMode({required BackgroundLogoutMode backgroundLogoutMode}) async {
    await _autoLogoutSettingsService.saveBackgroundLogoutMode(backgroundLogoutMode);
    emit(state.copyWith(backgroundLogoutMode: backgroundLogoutMode));
  }

  Future<void> setInactivityEnabled({required bool inactivityLogoutEnabledBool}) async {
    await _autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool);
    emit(state.copyWith(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool));
  }

  Future<void> setInactivityLogoutTimer({required InactivityLogoutTimer inactivityLogoutTimer}) async {
    await _autoLogoutSettingsService.saveInactivityLogoutTimer(inactivityLogoutTimer);
    emit(state.copyWith(inactivityLogoutTimer: inactivityLogoutTimer));
  }
}
