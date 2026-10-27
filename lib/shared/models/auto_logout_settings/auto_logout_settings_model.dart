import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';

class AutoLogoutSettingsModel {
  const AutoLogoutSettingsModel({
    required this.inactivityLogoutBool,
    required this.backgroundLogoutMode,
    required this.inactivityLogoutTimeout,
  });

  static const bool defaultInactivityLogoutBool = true;
  static const BackgroundLogoutMode defaultBackgroundLogoutMode = BackgroundLogoutMode.on;
  static const InactivityLogoutTimer defaultInactivityLogoutTimeout = InactivityLogoutTimer.oneMinute;

  final bool inactivityLogoutBool;
  final BackgroundLogoutMode backgroundLogoutMode;
  final InactivityLogoutTimer inactivityLogoutTimeout;
}
