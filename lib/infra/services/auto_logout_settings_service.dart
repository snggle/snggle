import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/auto_logout_settings_entity/auto_logout_settings_entity.dart';
import 'package:snggle/infra/repositories/auto_logout_settings_repository.dart';
import 'package:snggle/shared/factories/auto_logout_settings_model_factory.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';

class AutoLogoutSettingsService {
  final AutoLogoutSettingsModelFactory _autoLogoutSettingsModelFactory = globalLocator<AutoLogoutSettingsModelFactory>();
  final AutoLogoutSettingsRepository _settingsRepository = globalLocator<AutoLogoutSettingsRepository>();

  Future<AutoLogoutSettingsModel> getAutoLogoutSettings() async {
    AutoLogoutSettingsEntity? settingsEntity = await _settingsRepository.getSettings();
    return _autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);
  }

  Future<void> saveBackgroundLogoutMode(BackgroundLogoutMode backgroundLogoutMode) {
    return _settingsRepository.saveSettings((AutoLogoutSettingsEntity settingsEntity) {
      settingsEntity.backgroundLogoutModeName = backgroundLogoutMode.name;
    });
  }

  Future<void> saveInactivityEnabledBool({required bool inactivityLogoutEnabledBool}) {
    return _settingsRepository.saveSettings((AutoLogoutSettingsEntity settingsEntity) {
      AutoLogoutSettingsModel autoLogoutSettingsModel = _autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      settingsEntity
        ..inactivityLogoutEnabledBool = inactivityLogoutEnabledBool
        ..inactivityLogoutTimeoutName = autoLogoutSettingsModel.inactivityLogoutTimeout.name;
    });
  }

  Future<void> saveInactivityLogoutTimeout(InactivityLogoutTimeout inactivityLogoutTimeout) async {
    await _settingsRepository.saveSettings((AutoLogoutSettingsEntity settingsEntity) {
      AutoLogoutSettingsModel autoLogoutSettingsModel = _autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      settingsEntity
        ..inactivityLogoutEnabledBool = autoLogoutSettingsModel.inactivityLogoutBool
        ..inactivityLogoutTimeoutName = inactivityLogoutTimeout.name;
    });
  }
}
