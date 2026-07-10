import 'package:isar_community/isar.dart';

part 'settings_entity.g.dart';

@Collection(accessor: 'settings')
class SettingsEntity {
  static const int settingsId = 1;

  Id id = settingsId;
  bool inactivityLogoutEnabledBool = true;
  String? inactivityLogoutTimeoutName;
  String? automaticLogoutModeName;
}
