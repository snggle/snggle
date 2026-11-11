import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';

class AutoLogoutSettingsModel {
  const AutoLogoutSettingsModel({
    required this.inactivityLogoutBool,
    required this.backgroundLogoutMode,
    required this.inactivityLogoutTimer,
  });

  static const bool defaultInactivityLogoutBool = false;
  static const BackgroundLogoutMode defaultBackgroundLogoutMode = BackgroundLogoutMode.on;
  static const InactivityLogoutTimer defaultInactivityLogoutTimer = InactivityLogoutTimer.oneMinute;

  final bool inactivityLogoutBool;
  final BackgroundLogoutMode backgroundLogoutMode;
  final InactivityLogoutTimer inactivityLogoutTimer;
}
