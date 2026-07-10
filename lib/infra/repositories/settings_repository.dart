import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';

class SettingsRepository {
  SettingsRepository({IsarDatabaseManager? isarDatabaseManager}) : _isarDatabaseManager = isarDatabaseManager ?? globalLocator<IsarDatabaseManager>();

  final IsarDatabaseManager _isarDatabaseManager;

  Future<SettingsEntity?> getSettings() {
    return _isarDatabaseManager.perform((Isar isar) {
      return isar.settings.get(SettingsEntity.settingsId);
    });
  }

  Future<void> saveSettings(void Function(SettingsEntity settingsEntity) updateSettingsCallback) {
    return _isarDatabaseManager.perform((Isar isar) {
      return isar.writeTxn(() async {
        SettingsEntity settingsEntity = await isar.settings.get(SettingsEntity.settingsId) ?? SettingsEntity();

        updateSettingsCallback(settingsEntity);
        await isar.settings.put(settingsEntity);
      });
    });
  }
}
