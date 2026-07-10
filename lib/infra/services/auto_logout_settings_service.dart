import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/infra/repositories/settings_repository.dart';
import 'package:snggle/shared/factories/auto_logout_settings_model_factory.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';

class AutoLogoutSettingsService {
  final AutoLogoutSettingsModelFactory _autoLogoutSettingsModelFactory = globalLocator<AutoLogoutSettingsModelFactory>();
  final SettingsRepository _settingsRepository = globalLocator<SettingsRepository>();

  Future<AutoLogoutSettingsModel> getAutoLogoutSettings() async {
    SettingsEntity? settingsEntity = await _settingsRepository.getSettings();
    return _autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);
  }

  Future<void> saveAutomaticLogoutMode(AutomaticLogoutMode automaticLogoutMode) {
    return _settingsRepository.saveSettings((SettingsEntity settingsEntity) {
      settingsEntity.automaticLogoutModeName = automaticLogoutMode.name;
    });
  }

  Future<void> saveInactivityEnabledBool({required bool inactivityLogoutEnabledBool}) {
    return _settingsRepository.saveSettings((SettingsEntity settingsEntity) {
      AutoLogoutSettingsModel autoLogoutSettingsModel = _autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      settingsEntity
        ..inactivityLogoutEnabledBool = inactivityLogoutEnabledBool
        ..inactivityLogoutTimeoutName = autoLogoutSettingsModel.inactivityLogoutTimeout.name;
    });
  }

  Future<void> saveInactivityLogoutTimeout(InactivityLogoutTimeout inactivityLogoutTimeout) async {
    await _settingsRepository.saveSettings((SettingsEntity settingsEntity) {
      AutoLogoutSettingsModel autoLogoutSettingsModel = _autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      settingsEntity
        ..inactivityLogoutEnabledBool = autoLogoutSettingsModel.inactivityLogoutBool
        ..inactivityLogoutTimeoutName = inactivityLogoutTimeout.name;
    });
  }
}
