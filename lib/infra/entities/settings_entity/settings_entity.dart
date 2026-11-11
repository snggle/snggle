import 'package:isar_community/isar.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';

part 'settings_entity.g.dart';

@Collection(accessor: 'settings')
class SettingsEntity {
  static const int settingsId = 1;

  Id id = settingsId;
  bool inactivityLogoutEnabledBool = false;

  @Name('inactivityLogoutTimerName')
  @Enumerated(EnumType.name)
  InactivityLogoutTimer? inactivityLogoutTimer;

  @Name('backgroundLogoutModeName')
  @Enumerated(EnumType.name)
  BackgroundLogoutMode? backgroundLogoutMode;
}
