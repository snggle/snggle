import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/infra/repositories/settings_repository.dart';
import 'package:snggle/infra/services/auto_logout_settings_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late AutoLogoutSettingsService actualAutoLogoutSettingsService;
  late SettingsRepository settingsRepository;

  setUp(() async {
    testDatabase = TestDatabase();
    await testDatabase.init(databaseMock: DatabaseMock.emptyDatabaseMock, appPasswordModel: PasswordModel.fromPlaintext('1111'));

    actualAutoLogoutSettingsService = globalLocator<AutoLogoutSettingsService>();
    settingsRepository = globalLocator<SettingsRepository>();
  });

  tearDown(() async {
    await testDatabase.close();
  });

  group('Tests of AutoLogoutSettingsService.getAutoLogoutSettings()', () {
    test('Should [return defaults without creating a record] if [settings do not exist]', () async {
      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.oneMinute);
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
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
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
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);

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
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.oneMinute);
    });
  });

  group('Tests of AutoLogoutSettingsService.saveBackgroundLogoutMode()', () {
    test('Should [create a settings record] if [settings do not exist]', () async {
      // Act
      await actualAutoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);

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
      await actualAutoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.on);

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
      await actualAutoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });
  });

  group('Tests of AutoLogoutSettingsService.saveInactivityEnabledBool()', () {
    test('Should [save false] and [preserve mode and timeout]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = true
          ..backgroundLogoutMode = BackgroundLogoutMode.off
          ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;
      });

      // Act
      await actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);

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
      await actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: true);

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
      await actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimer, isNull);
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);

      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
    });

    test('Should [create a settings record without persisting defaults] if [settings do not exist]', () async {
      // Act
      await actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity, isNotNull);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.backgroundLogoutMode, isNull);
      expect(actualSettingsEntity?.inactivityLogoutTimer, isNull);

      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
    });
  });

  group('Tests of AutoLogoutSettingsService.saveInactivityLogoutTimer()', () {
    test('Should [save oneMinute] and [preserve disabled logout switches]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutMode = BackgroundLogoutMode.off
          ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;
      });

      // Act
      await actualAutoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.oneMinute);

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
      await actualAutoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
    });

    test('Should [create settings with inactivity disabled by default] if [settings do not exist]', () async {
      // Act
      await actualAutoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.backgroundLogoutMode, isNull);
    });
  });

  group('Tests of AutoLogoutSettingsService simultaneous saves', () {
    test('Should [preserve every change] when [different settings are saved simultaneously]', () async {
      // Act
      await Future.wait<void>(<Future<void>>[
        actualAutoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off),
        actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false),
        actualAutoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes),
      ]);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });
  });
}