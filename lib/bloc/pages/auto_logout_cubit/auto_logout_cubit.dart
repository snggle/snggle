import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/infra/repositories/settings_repository.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dar.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactive_logout_timeout.dart';

part 'auto_logout_state.dart';

class AutoLogoutCubit extends Cubit<AutoLogoutState> {
  AutoLogoutCubit({SettingsRepository? settingsRepository})
    : _settingsRepository = settingsRepository ?? SettingsRepository(),
      super(
        const AutoLogoutState(
          inactivityLogoutTimeout: AutoLogoutSettingsModel.defaultInactivityLogoutTimeout,
          automaticLogoutMode: AutoLogoutSettingsModel.defaultAutomaticLogoutMode,
          inactivityLogoutEnabledBool: AutoLogoutSettingsModel.defaultInactivityLogoutBool,
        ),
      );

  final SettingsRepository _settingsRepository;

  Future<void> init() async {
    AutoLogoutSettingsModel autoLogoutSettingsModel = await _settingsRepository.getAutoLogoutSettings();

    emit(
      state.copyWith(
        automaticLogoutMode: autoLogoutSettingsModel.automaticLogoutMode,
        inactivityLogoutEnabledBool: autoLogoutSettingsModel.inactivityLogoutBool,
        inactivityLogoutTimeout: autoLogoutSettingsModel.inactivityLogoutTimeout,
      ),
    );
  }

  Future<void> setAutomaticLogoutMode({
    required AutomaticLogoutMode automaticLogoutMode,
  }) async {
    await _settingsRepository.saveAutomaticLogoutMode(
      automaticLogoutMode,
    );

    emit(state.copyWith(automaticLogoutMode: automaticLogoutMode));
  }

  Future<void> setInactivityEnabledBool({required bool inactivityLogoutEnabledBool}) async {
    await _settingsRepository.saveInactivityEnabledBool(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool);

    emit(state.copyWith(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool));
  }

  Future<void> setInactivityLogoutTimeout({required InactivityLogoutTimeout inactivityLogoutTimeout}) async {
    await _settingsRepository.saveInactivityLogoutTimeout(inactivityLogoutTimeout);

    emit(
      state.copyWith(inactivityLogoutTimeout: inactivityLogoutTimeout),
    );
  }
}
