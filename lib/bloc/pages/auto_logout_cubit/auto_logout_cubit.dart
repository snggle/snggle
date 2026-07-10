import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/auto_logout_settings_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';

part 'auto_logout_state.dart';

class AutoLogoutCubit extends Cubit<AutoLogoutState> {
  final AutoLogoutSettingsService _autoLogoutSettingsService = globalLocator<AutoLogoutSettingsService>();

  AutoLogoutCubit()
    : super(
        const AutoLogoutState(
          inactivityLogoutEnabledBool: AutoLogoutSettingsModel.defaultInactivityLogoutBool,
          automaticLogoutMode: AutoLogoutSettingsModel.defaultAutomaticLogoutMode,
          inactivityLogoutTimeout: AutoLogoutSettingsModel.defaultInactivityLogoutTimeout,
        ),
      );

  Future<void> init() async {
    AutoLogoutSettingsModel autoLogoutSettingsModel = await _autoLogoutSettingsService.getAutoLogoutSettings();
    emit(
      state.copyWith(
        inactivityLogoutEnabledBool: autoLogoutSettingsModel.inactivityLogoutBool,
        automaticLogoutMode: autoLogoutSettingsModel.automaticLogoutMode,
        inactivityLogoutTimeout: autoLogoutSettingsModel.inactivityLogoutTimeout,
      ),
    );
  }

  Future<void> setAutomaticLogoutMode({required AutomaticLogoutMode automaticLogoutMode}) async {
    await _autoLogoutSettingsService.saveAutomaticLogoutMode(automaticLogoutMode);
    emit(state.copyWith(automaticLogoutMode: automaticLogoutMode));
  }

  Future<void> setInactivityEnabledBool({required bool inactivityLogoutEnabledBool}) async {
    await _autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool);
    emit(state.copyWith(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool));
  }

  Future<void> setInactivityLogoutTimeout({required InactivityLogoutTimeout inactivityLogoutTimeout}) async {
    await _autoLogoutSettingsService.saveInactivityLogoutTimeout(inactivityLogoutTimeout);
    emit(state.copyWith(inactivityLogoutTimeout: inactivityLogoutTimeout));
  }
}
