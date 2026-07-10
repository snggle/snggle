import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/infra/repositories/settings_repository.dart';
import 'package:snggle/shared/models/automatic_logout_mode.dart';
import 'package:snggle/shared/models/inactive_logout_timeout.dart';

part 'auto_logout_state.dart';

class AutoLogoutCubit extends Cubit<AutoLogoutState> {
  AutoLogoutCubit()
    : super(
        const AutoLogoutState(
          automaticLogoutMode: SettingsRepository.defaultAutomaticLogoutMode,
          inactivityLogoutEnabledBool: SettingsRepository.defaultInactivityLogoutEnabledBool,
          inactivityLogoutTimeout: SettingsRepository.defaultInactivityLogoutTimeout,
        ),
      );

  final SettingsRepository _settingsRepository = SettingsRepository();

  Future<void> init() async {
    final AutomaticLogoutMode automaticLogoutMode = await _settingsRepository.getAutomaticLogoutMode();

    final bool inactivityLogoutEnabledBool = await _settingsRepository.getInactivityLogoutEnabledBool();

    final InactivityLogoutTimeout inactivityLogoutTimeout = await _settingsRepository.getInactivityLogoutTimeout();

    emit(
      state.copyWith(
        automaticLogoutMode: automaticLogoutMode,
        inactivityLogoutEnabledBool: inactivityLogoutEnabledBool,
        inactivityLogoutTimeout: inactivityLogoutTimeout,
      ),
    );
  }

  Future<void> setAutomaticLogoutMode({
    required AutomaticLogoutMode automaticLogoutMode,
  }) async {
    await _settingsRepository.saveAutomaticLogoutMode(
      automaticLogoutMode,
    );

    emit(
      state.copyWith(
        automaticLogoutMode: automaticLogoutMode,
      ),
    );
  }

  Future<void> setInactivityLogoutEnabledBool({
    required bool inactivityLogoutEnabledBool,
  }) async {
    await _settingsRepository.saveInactivityLogoutEnabledBool(
      inactivityLogoutEnabledBool: inactivityLogoutEnabledBool,
    );

    emit(
      state.copyWith(
        inactivityLogoutEnabledBool: inactivityLogoutEnabledBool,
      ),
    );
  }

  Future<void> setInactivityLogoutTimeout({
    required InactivityLogoutTimeout inactivityLogoutTimeout,
  }) async {
    await _settingsRepository.saveInactivityLogoutTimeout(
      inactivityLogoutTimeout,
    );

    emit(
      state.copyWith(
        inactivityLogoutTimeout: inactivityLogoutTimeout,
      ),
    );
  }
}
