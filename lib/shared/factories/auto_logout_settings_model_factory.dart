import 'package:snggle/infra/entities/auto_logout_settings_entity/auto_logout_settings_entity.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';

class AutoLogoutSettingsModelFactory {
  AutoLogoutSettingsModel createFromEntity(AutoLogoutSettingsEntity? settingsEntity) {
    BackgroundLogoutMode automaticLogoutMode = BackgroundLogoutMode.values.firstWhere(
      (BackgroundLogoutMode automaticLogoutMode) => automaticLogoutMode.name == settingsEntity?.backgroundLogoutModeName,
      orElse: () => AutoLogoutSettingsModel.defaultBackgroundLogoutMode,
    );

    InactivityLogoutTimer inactivityLogoutTimer = InactivityLogoutTimer.values.firstWhere(
      (InactivityLogoutTimer inactivityLogoutTimer) => inactivityLogoutTimer.name == settingsEntity?.inactivityLogoutTimerName,
      orElse: () => AutoLogoutSettingsModel.defaultInactivityLogoutTimer,
    );

    bool inactivityLogoutEnabledBool = settingsEntity?.inactivityLogoutEnabledBool ?? AutoLogoutSettingsModel.defaultInactivityLogoutBool;

    return AutoLogoutSettingsModel(
      inactivityLogoutBool: inactivityLogoutEnabledBool,
      backgroundLogoutMode: automaticLogoutMode,
      inactivityLogoutTimer: inactivityLogoutTimer,
    );
  }
}
