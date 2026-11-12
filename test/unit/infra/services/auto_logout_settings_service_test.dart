import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/infra/repositories/auto_logout_settings_repository.dart';
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
  late AutoLogoutSettingsRepository settingsRepository;

  setUp(() async {
    testDatabase = TestDatabase();
    await testDatabase.init(databaseMock: DatabaseMock.emptyDatabaseMock, appPasswordModel: PasswordModel.fromPlaintext('1111'));

    actualAutoLogoutSettingsService = globalLocator<AutoLogoutSettingsService>();
    settingsRepository = globalLocator<AutoLogoutSettingsRepository>();
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
          ..backgroundLogoutModeName = BackgroundLogoutMode.off.name
          ..inactivityLogoutTimerName = InactivityLogoutTimer.fiveMinutes.name;
      });

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [use default enum values] if [stored names are invalid] without changing the stored entity', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = 'invalid_mode'
          ..inactivityLogoutTimerName = 'invalid_timeout';
      });

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);

      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutModeName, 'invalid_mode');
      expect(actualSettingsEntity?.inactivityLogoutTimerName, 'invalid_timeout');
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
      expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimerName, isNull);
    });

    for (BackgroundLogoutMode automaticLogoutMode in BackgroundLogoutMode.values) {
      test('Should [save ${automaticLogoutMode.name}] and [preserve inactivity settings]', () async {
        // Arrange
        BackgroundLogoutMode initialAutomaticLogoutMode = automaticLogoutMode == BackgroundLogoutMode.on
            ? BackgroundLogoutMode.off
            : BackgroundLogoutMode.on;

        await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
          settingsEntity
            ..inactivityLogoutEnabledBool = false
            ..backgroundLogoutModeName = initialAutomaticLogoutMode.name
            ..inactivityLogoutTimerName = InactivityLogoutTimer.fiveMinutes.name;
        });

        // Act
        await actualAutoLogoutSettingsService.saveBackgroundLogoutMode(automaticLogoutMode);

        // Assert
        SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
        expect(actualSettingsEntity?.backgroundLogoutModeName, automaticLogoutMode.name);
        expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
        expect(actualSettingsEntity?.inactivityLogoutTimerName, InactivityLogoutTimer.fiveMinutes.name);
      });
    }
  });

  group('Tests of AutoLogoutSettingsService.saveInactivityEnabledBool()', () {
    for (bool inactivityLogoutEnabledBool in <bool>[false, true]) {
      test('Should [save $inactivityLogoutEnabledBool] and [preserve mode and timeout]', () async {
        // Arrange
        await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
          settingsEntity
            ..inactivityLogoutEnabledBool = !inactivityLogoutEnabledBool
            ..backgroundLogoutModeName = BackgroundLogoutMode.off.name
            ..inactivityLogoutTimerName = InactivityLogoutTimer.fiveMinutes.name;
        });

        // Act
        await actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool);

        // Assert
        SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
        expect(actualSettingsEntity?.inactivityLogoutEnabledBool, inactivityLogoutEnabledBool);
        expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);
        expect(actualSettingsEntity?.inactivityLogoutTimerName, InactivityLogoutTimer.fiveMinutes.name);
      });
    }

    test('Should [preserve a null timeout] and [return the default timeout when reading settings]', () async {
      // Arrange
      await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity.backgroundLogoutModeName = BackgroundLogoutMode.off.name;
      });

      // Act
      await actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimerName, isNull);
      expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);

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
      expect(actualSettingsEntity?.backgroundLogoutModeName, isNull);
      expect(actualSettingsEntity?.inactivityLogoutTimerName, isNull);

      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
    });
  });

  group('Tests of AutoLogoutSettingsService.saveInactivityLogoutTimer()', () {
    for (InactivityLogoutTimer inactivityLogoutTimer in <InactivityLogoutTimer>[
      InactivityLogoutTimer.oneMinute,
      InactivityLogoutTimer.fiveMinutes,
    ]) {
      test('Should [save ${inactivityLogoutTimer.name}] and [preserve disabled logout switches]', () async {
        // Arrange
        InactivityLogoutTimer initialInactivityLogoutTimer = inactivityLogoutTimer == InactivityLogoutTimer.oneMinute
            ? InactivityLogoutTimer.fiveMinutes
            : InactivityLogoutTimer.oneMinute;

        await settingsRepository.saveSettings((SettingsEntity settingsEntity) {
          settingsEntity
            ..inactivityLogoutEnabledBool = false
            ..backgroundLogoutModeName = BackgroundLogoutMode.off.name
            ..inactivityLogoutTimerName = initialInactivityLogoutTimer.name;
        });

        // Act
        await actualAutoLogoutSettingsService.saveInactivityLogoutTimer(inactivityLogoutTimer);

        // Assert
        SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
        expect(actualSettingsEntity?.inactivityLogoutTimerName, inactivityLogoutTimer.name);
        expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
        expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);
      });
    }

    test('Should [create settings with inactivity disabled by default] if [settings do not exist]', () async {
      // Act
      await actualAutoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);

      // Assert
      SettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutTimerName, InactivityLogoutTimer.fiveMinutes.name);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.backgroundLogoutModeName, isNull);
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
      expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimerName, InactivityLogoutTimer.fiveMinutes.name);
    });
  });
}
