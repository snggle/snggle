import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/models/automatic_logout_mode.dart';
import 'package:snggle/shared/models/inactive_logout_timeout.dart';

class SettingsRepository {
  final IsarDatabaseManager isarDatabaseManager = globalLocator<IsarDatabaseManager>();

  static const AutomaticLogoutMode defaultAutomaticLogoutMode = AutomaticLogoutMode.on;

  static const bool defaultInactivityLogoutEnabledBool = true;

  static const InactivityLogoutTimeout defaultInactivityLogoutTimeout = InactivityLogoutTimeout.oneMinute;

  Future<AutomaticLogoutMode> getAutomaticLogoutMode() async {
    final SettingsEntity? settingsEntity = await _getSettingsEntity();

    return AutomaticLogoutMode.values.firstWhere(
      (AutomaticLogoutMode mode) => mode.name == settingsEntity?.automaticLogoutModeName,
      orElse: () => defaultAutomaticLogoutMode,
    );
  }

  Future<bool> getInactivityLogoutEnabledBool() async {
    final SettingsEntity? settingsEntity = await _getSettingsEntity();

    return settingsEntity?.inactivityLogoutEnabledBool ?? defaultInactivityLogoutEnabledBool;
  }

  Future<InactivityLogoutTimeout> getInactivityLogoutTimeout() async {
    final SettingsEntity? settingsEntity = await _getSettingsEntity();

    return InactivityLogoutTimeout.values.firstWhere(
      (InactivityLogoutTimeout timeout) => timeout.name == settingsEntity?.inactivityLogoutTimeoutName,
      orElse: () => defaultInactivityLogoutTimeout,
    );
  }

  Future<void> saveAutomaticLogoutMode(
    AutomaticLogoutMode automaticLogoutMode,
  ) async {
    await _updateSettingsEntity(
      (SettingsEntity settingsEntity) {
        settingsEntity.automaticLogoutModeName = automaticLogoutMode.name;
      },
    );
  }

  Future<void> saveInactivityLogoutEnabledBool({required bool inactivityLogoutEnabledBool}) async {
    await _updateSettingsEntity(
      (SettingsEntity settingsEntity) {
        settingsEntity.inactivityLogoutEnabledBool = inactivityLogoutEnabledBool;
      },
    );
  }

  Future<void> saveInactivityLogoutTimeout(
    InactivityLogoutTimeout inactivityLogoutTimeout,
  ) async {
    await _updateSettingsEntity(
      (SettingsEntity settingsEntity) {
        settingsEntity.inactivityLogoutTimeoutName = inactivityLogoutTimeout.name;
      },
    );
  }

  Future<SettingsEntity?> _getSettingsEntity() {
    return isarDatabaseManager.perform((Isar isar) {
      return isar.settings.get(SettingsEntity.settingsId);
    });
  }

  Future<void> _updateSettingsEntity(
    void Function(SettingsEntity settingsEntity) update,
  ) async {
    await isarDatabaseManager.perform((Isar isar) async {
      await isar.writeTxn(() async {
        final SettingsEntity settingsEntity = await isar.settings.get(SettingsEntity.settingsId) ?? SettingsEntity();

        update(settingsEntity);

        await isar.settings.put(settingsEntity);
      });
    });
  }
}
