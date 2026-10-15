import 'package:snggle/infra/entities/auto_logout_settings_entity/auto_logout_settings_entity.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';

class AutoLogoutSettingsModelFactory {
  AutoLogoutSettingsModel createFromEntity(AutoLogoutSettingsEntity? settingsEntity) {
    AutomaticLogoutMode automaticLogoutMode = AutomaticLogoutMode.values.firstWhere(
      (AutomaticLogoutMode automaticLogoutMode) => automaticLogoutMode.name == settingsEntity?.automaticLogoutModeName,
      orElse: () => AutoLogoutSettingsModel.defaultAutomaticLogoutMode,
    );

    InactivityLogoutTimeout inactivityLogoutTimeout = InactivityLogoutTimeout.values.firstWhere(
      (InactivityLogoutTimeout inactivityLogoutTimeout) => inactivityLogoutTimeout.name == settingsEntity?.inactivityLogoutTimeoutName,
      orElse: () => AutoLogoutSettingsModel.defaultInactivityLogoutTimeout,
    );

    bool timeoutDisabledBool = inactivityLogoutTimeout == InactivityLogoutTimeout.off;
    bool inactivityLogoutEnabledBool = settingsEntity?.inactivityLogoutEnabledBool ?? AutoLogoutSettingsModel.defaultInactivityLogoutBool;

    return AutoLogoutSettingsModel(
      inactivityLogoutBool: !timeoutDisabledBool && inactivityLogoutEnabledBool,
      automaticLogoutMode: automaticLogoutMode,
      inactivityLogoutTimeout: timeoutDisabledBool ? AutoLogoutSettingsModel.defaultInactivityLogoutTimeout : inactivityLogoutTimeout,
    );
  }
}
