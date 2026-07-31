import 'package:isar_community/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dar.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactive_logout_timeout.dart';

class SettingsRepository {
  final IsarDatabaseManager _isarDatabaseManager;

  SettingsRepository({IsarDatabaseManager? isarDatabaseManager}) : _isarDatabaseManager = isarDatabaseManager ?? globalLocator<IsarDatabaseManager>();

  Future<AutoLogoutSettingsModel> getAutoLogoutSettings() async {
    SettingsEntity? settingsEntity = await _getSettingsEntity();
    bool inactivityLogoutEnabledBool = settingsEntity?.inactivityLogoutEnabledBool ?? AutoLogoutSettingsModel.defaultInactivityLogoutBool;

    AutomaticLogoutMode automaticLogoutMode = AutomaticLogoutMode.values.firstWhere((AutomaticLogoutMode automaticLogoutMode) {
      return automaticLogoutMode.name == settingsEntity?.automaticLogoutModeName;
    }, orElse: () => AutoLogoutSettingsModel.defaultAutomaticLogoutMode);

    InactivityLogoutTimeout inactivityLogoutTimeout = InactivityLogoutTimeout.values.firstWhere((InactivityLogoutTimeout inactivityLogoutTimeout) {
      return inactivityLogoutTimeout.name == settingsEntity?.inactivityLogoutTimeoutName;
    }, orElse: () => AutoLogoutSettingsModel.defaultInactivityLogoutTimeout);

    return AutoLogoutSettingsModel(
      inactivityLogoutBool: inactivityLogoutEnabledBool,
      automaticLogoutMode: automaticLogoutMode,
      inactivityLogoutTimeout: inactivityLogoutTimeout,
    );
  }

  Future<void> saveAutomaticLogoutMode(
    AutomaticLogoutMode automaticLogoutMode,
  ) async {
    await _updateSettings((SettingsEntity settingsEntity) {
      settingsEntity.automaticLogoutModeName = automaticLogoutMode.name;
    });
  }

  Future<void> saveInactivityEnabledBool({required bool inactivityLogoutEnabledBool}) async {
    await _updateSettings((SettingsEntity settingsEntity) {
      settingsEntity.inactivityLogoutEnabledBool = inactivityLogoutEnabledBool;
    });
  }

  Future<void> saveInactivityLogoutTimeout(
    InactivityLogoutTimeout inactivityLogoutTimeout,
  ) async {
    await _updateSettings((SettingsEntity settingsEntity) {
      settingsEntity.inactivityLogoutTimeoutName = inactivityLogoutTimeout.name;
    });
  }

  Future<SettingsEntity?> _getSettingsEntity() {
    return _isarDatabaseManager.perform((Isar isar) {
      return isar.settings.get(SettingsEntity.settingsId);
    });
  }

  Future<void> _updateSettings(
    void Function(SettingsEntity settingsEntity) updateSettingsEntity,
  ) async {
    await _isarDatabaseManager.perform((Isar isar) async {
      await isar.writeTxn(() async {
        final SettingsEntity settingsEntity = await isar.settings.get(SettingsEntity.settingsId) ?? SettingsEntity();

        updateSettingsEntity(settingsEntity);

        await isar.settings.put(settingsEntity);
      });
    });
  }
}
