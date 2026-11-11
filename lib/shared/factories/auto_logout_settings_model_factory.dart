import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';

class AutoLogoutSettingsModelFactory {
  AutoLogoutSettingsModel createFromEntity(SettingsEntity? settingsEntity) {
    BackgroundLogoutMode backgroundLogoutMode = settingsEntity?.backgroundLogoutMode ?? AutoLogoutSettingsModel.defaultBackgroundLogoutMode;
    InactivityLogoutTimer inactivityLogoutTimer = settingsEntity?.inactivityLogoutTimer ?? AutoLogoutSettingsModel.defaultInactivityLogoutTimer;
    bool inactivityLogoutEnabledBool = settingsEntity?.inactivityLogoutEnabledBool ?? AutoLogoutSettingsModel.defaultInactivityLogoutBool;

    return AutoLogoutSettingsModel(
      inactivityLogoutBool: inactivityLogoutEnabledBool,
      backgroundLogoutMode: backgroundLogoutMode,
      inactivityLogoutTimer: inactivityLogoutTimer,
    );
  }
}
