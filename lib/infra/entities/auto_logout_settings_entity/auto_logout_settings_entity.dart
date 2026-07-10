import 'package:isar_community/isar.dart';

part 'auto_logout_settings_entity.g.dart';

@Collection(accessor: 'autoLogoutSettings')
class AutoLogoutSettingsEntity {
  static const int autoLogoutSettingsId = 1;

  Id id = autoLogoutSettingsId;
  bool inactivityLogoutEnabledBool = true;
  String? inactivityLogoutTimeoutName;
  String? backgroundLogoutModeName;
}
