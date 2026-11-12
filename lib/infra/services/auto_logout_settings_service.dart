import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/infra/repositories/auto_logout_settings_repository.dart';
import 'package:snggle/shared/factories/auto_logout_settings_model_factory.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';

class AutoLogoutSettingsService {
  final AutoLogoutSettingsModelFactory _autoLogoutSettingsModelFactory = AutoLogoutSettingsModelFactory();
  final AutoLogoutSettingsRepository _settingsRepository = globalLocator<AutoLogoutSettingsRepository>();

  Future<AutoLogoutSettingsModel> getAutoLogoutSettings() async {
    SettingsEntity? settingsEntity = await _settingsRepository.getSettings();
    return _autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);
  }

  Future<void> saveBackgroundLogoutMode(BackgroundLogoutMode backgroundLogoutMode) {
    return _settingsRepository.saveSettings((SettingsEntity settingsEntity) {
      settingsEntity.backgroundLogoutModeName = backgroundLogoutMode.name;
    });
  }

  Future<void> saveInactivityEnabledBool({required bool inactivityLogoutEnabledBool}) {
    return _settingsRepository.saveSettings(
      (SettingsEntity settingsEntity) {
        settingsEntity.inactivityLogoutEnabledBool = inactivityLogoutEnabledBool;
      },
    );
  }

  Future<void> saveInactivityLogoutTimer(InactivityLogoutTimer inactivityLogoutTimer) {
    return _settingsRepository.saveSettings(
      (SettingsEntity settingsEntity) {
        settingsEntity.inactivityLogoutTimerName = inactivityLogoutTimer.name;
      },
    );
  }
}
