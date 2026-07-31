import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactive_logout_timeout.dart';

class AutoLogoutSettingsModel {
  const AutoLogoutSettingsModel({
    required this.inactivityLogoutBool,
    required this.automaticLogoutMode,
    required this.inactivityLogoutTimeout,
  });

  static const bool defaultInactivityLogoutBool = true;
  static const AutomaticLogoutMode defaultAutomaticLogoutMode = AutomaticLogoutMode.on;
  static const InactivityLogoutTimeout defaultInactivityLogoutTimeout = InactivityLogoutTimeout.oneMinute;

  final bool inactivityLogoutBool;
  final AutomaticLogoutMode automaticLogoutMode;
  final InactivityLogoutTimeout inactivityLogoutTimeout;
}
