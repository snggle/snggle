import 'package:isar_community/isar.dart';

part 'settings_entity.g.dart';

@Collection(accessor: 'settings')
class SettingsEntity {
  static const int autoLogoutSettingsId = 1;

  Id id = autoLogoutSettingsId;
  bool inactivityLogoutEnabledBool = false;
  String? inactivityLogoutTimerName;
  String? backgroundLogoutModeName;
}
