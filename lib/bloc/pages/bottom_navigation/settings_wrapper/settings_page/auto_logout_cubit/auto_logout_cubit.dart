import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/settings_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
import 'package:snggle/shared/models/auto_logout_settings/settings_model.dart';

part 'auto_logout_state.dart';

class AutoLogoutCubit extends Cubit<AutoLogoutState> {
  final SettingsService _settingsService = globalLocator<SettingsService>();

  AutoLogoutCubit()
    : super(
        const AutoLogoutState(
          inactivityLogoutEnabledBool: SettingsModel.defaultInactivityLogoutBool,
          backgroundLogoutMode: SettingsModel.defaultBackgroundLogoutMode,
          inactivityLogoutTimer: SettingsModel.defaultInactivityLogoutTimer,
        ),
      );

  Future<void> init() async {
    SettingsModel settingsModel = await _settingsService.getSettings();
    emit(
      state.copyWith(
        inactivityLogoutEnabledBool: settingsModel.inactivityLogoutBool,
        backgroundLogoutMode: settingsModel.backgroundLogoutMode,
        inactivityLogoutTimer: settingsModel.inactivityLogoutTimer,
      ),
    );
  }

  Future<void> setBackgroundLogoutMode({required BackgroundLogoutMode backgroundLogoutMode}) async {
    await _settingsService.saveBackgroundLogoutMode(backgroundLogoutMode);
    emit(state.copyWith(backgroundLogoutMode: backgroundLogoutMode));
  }

  Future<void> setInactivityEnabled({required bool inactivityLogoutEnabledBool}) async {
    await _settingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool);
    emit(state.copyWith(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool));
  }

  Future<void> setInactivityLogoutTimer({required InactivityLogoutTimer inactivityLogoutTimer}) async {
    await _settingsService.saveInactivityLogoutTimer(inactivityLogoutTimer);
    emit(state.copyWith(inactivityLogoutTimer: inactivityLogoutTimer));
  }
}
