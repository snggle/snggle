import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/auto_logout_settings_entity/auto_logout_settings_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';

class AutoLogoutSettingsRepository {
  AutoLogoutSettingsRepository({IsarDatabaseManager? isarDatabaseManager})
      : _isarDatabaseManager =
      isarDatabaseManager ?? globalLocator<IsarDatabaseManager>();

  final IsarDatabaseManager _isarDatabaseManager;

  Future<AutoLogoutSettingsEntity?> getSettings() {
    return _isarDatabaseManager.perform((Isar isar) {
      return isar.autoLogoutSettings.get(
        AutoLogoutSettingsEntity.autoLogoutSettingsId,
      );
    });
  }

  Future<void> saveSettings(
      void Function(AutoLogoutSettingsEntity settingsEntity) updateSettingsCallback,
      ) {
    return _isarDatabaseManager.perform((Isar isar) {
      return isar.writeTxn(() async {
        AutoLogoutSettingsEntity settingsEntity =
            await isar.autoLogoutSettings.get(
              AutoLogoutSettingsEntity.autoLogoutSettingsId,
            ) ??
                AutoLogoutSettingsEntity();

        updateSettingsCallback(settingsEntity);
        await isar.autoLogoutSettings.put(settingsEntity);
      });
    });
  }
}