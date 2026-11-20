import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
import 'package:snggle/shared/models/auto_logout_settings/settings_model.dart';

class SettingsModelFactory {
  SettingsModel createFromEntity(SettingsEntity? settingsEntity) {
    BackgroundLogoutMode backgroundLogoutMode = settingsEntity?.backgroundLogoutMode ?? SettingsModel.defaultBackgroundLogoutMode;
    InactivityLogoutTimer inactivityLogoutTimer = settingsEntity?.inactivityLogoutTimer ?? SettingsModel.defaultInactivityLogoutTimer;
    bool inactivityLogoutEnabledBool = settingsEntity?.inactivityLogoutEnabledBool ?? SettingsModel.defaultInactivityLogoutBool;

    return SettingsModel(
      inactivityLogoutBool: inactivityLogoutEnabledBool,
      backgroundLogoutMode: backgroundLogoutMode,
      inactivityLogoutTimer: inactivityLogoutTimer,
    );
  }
}
