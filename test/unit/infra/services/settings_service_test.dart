import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/infra/repositories/settings_repository.dart';
import 'package:snggle/infra/services/settings_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
import 'package:snggle/shared/models/auto_logout_settings/settings_model.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late SettingsService actualSettingsService;
  late SettingsRepository settingsRepository;

  setUp(() async {
    testDatabase = TestDatabase();
    await testDatabase.init(databaseMock: DatabaseMock.emptyDatabaseMock, appPasswordModel: PasswordModel.fromPlaintext('1111'));

    actualSettingsService = globalLocator<SettingsService>();
    settingsRepository = globalLocator<SettingsRepository>();
  });

  tearDown(() async {
    await testDatabase.close();
  });

  group('Tests of SettingsService.getSettings()', () {
    test('Should [return defaults without creating a record] if [settings do not exist]', () async {
      // Act
      SettingsModel actualSettingsModel = await actualSettingsService.getSettings();

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, false);
      expect(actualSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.oneMinute);
      expect(await settingsRepository.getSettings(), isNull);
    });

    test('Should [return saved settings] if [all settings exist]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutMode = BackgroundLogoutMode.off
          ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;
      });

      // Act
      SettingsModel actualSettingsModel = await actualSettingsService.getSettings();

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, false);
      expect(actualSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [use the default background mode] if [stored mode is null] without changing stored settings', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = true
          ..backgroundLogoutMode = null
          ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;
      });

      // Act
      SettingsModel actualSettingsModel = await actualSettingsService.getSettings();

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, true);
      expect(actualSettingsModel.backgroundLogoutMode, SettingsModel.defaultBackgroundLogoutMode);
      expect(actualSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);

      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutMode, isNull);
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [use defaults for missing values] and [preserve a saved false flag]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity.inactivityLogoutEnabledBool = false;
      });

      // Act
      SettingsModel actualSettingsModel = await actualSettingsService.getSettings();

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, false);
      expect(actualSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.oneMinute);
    });
  });

  group('Tests of SettingsService.saveBackgroundLogoutMode()', () {
    test('Should [create a settings record] if [settings do not exist]', () async {
      // Act
      await actualSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimer, isNull);
    });

    test('Should [save on] and [preserve inactivity settings]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutMode = BackgroundLogoutMode.off
          ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;
      });

      // Act
      await actualSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.on);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [save off] and [preserve inactivity settings]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutMode = BackgroundLogoutMode.on
          ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;
      });

      // Act
      await actualSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });
  });

  group('Tests of SettingsService.saveInactivityEnabledBool()', () {
    test('Should [save false] and [preserve mode and timeout]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = true
          ..backgroundLogoutMode = BackgroundLogoutMode.off
          ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;
      });

      // Act
      await actualSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [save true] and [preserve mode and timeout]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutMode = BackgroundLogoutMode.off
          ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;
      });

      // Act
      await actualSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: true);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, true);
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [preserve a null timeout] and [return the default timeout when reading settings]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity.backgroundLogoutMode = BackgroundLogoutMode.off;
      });

      // Act
      await actualSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimer, isNull);
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);

      SettingsModel actualSettingsModel = await actualSettingsService.getSettings();
      expect(actualSettingsModel.inactivityLogoutBool, false);
      expect(actualSettingsModel.inactivityLogoutTimer, SettingsModel.defaultInactivityLogoutTimer);
      expect(actualSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
    });

    test('Should [create a settings record without persisting defaults] if [settings do not exist]', () async {
      // Act
      await actualSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity, isNotNull);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.backgroundLogoutMode, isNull);
      expect(actualSettingsEntity?.inactivityLogoutTimer, isNull);

      SettingsModel actualSettingsModel = await actualSettingsService.getSettings();
      expect(actualSettingsModel.inactivityLogoutBool, false);
      expect(actualSettingsModel.backgroundLogoutMode, SettingsModel.defaultBackgroundLogoutMode);
      expect(actualSettingsModel.inactivityLogoutTimer, SettingsModel.defaultInactivityLogoutTimer);
    });
  });

  group('Tests of SettingsService.saveInactivityLogoutTimer()', () {
    test('Should [save oneMinute] and [preserve disabled logout switches]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutMode = BackgroundLogoutMode.off
          ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;
      });

      // Act
      await actualSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.oneMinute);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.oneMinute);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
    });

    test('Should [save fiveMinutes] and [preserve disabled logout switches]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutMode = BackgroundLogoutMode.off
          ..inactivityLogoutTimer = InactivityLogoutTimer.oneMinute;
      });

      // Act
      await actualSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
    });

    test('Should [create settings with inactivity disabled by default] if [settings do not exist]', () async {
      // Act
      await actualSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.backgroundLogoutMode, isNull);
    });
  });

  group('Tests of SettingsService simultaneous saves', () {
    test('Should [preserve every change] when [different settings are saved simultaneously]', () async {
      // Act
      await Future.wait<void>(<Future<void>>[
        actualSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off),
        actualSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false),
        actualSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes),
      ]);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });
  });
}
