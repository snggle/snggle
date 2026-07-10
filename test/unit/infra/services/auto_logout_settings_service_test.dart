import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/auto_logout_settings_entity/auto_logout_settings_entity.dart';
import 'package:snggle/infra/repositories/auto_logout_settings_repository.dart';
import 'package:snggle/infra/services/auto_logout_settings_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';
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
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimeout.oneMinute);
      expect(await settingsRepository.getSettings(), isNull);
    });

    test('Should [return saved settings] if [all settings exist]', () async {
      // Arrange
      await settingsRepository.saveSettings((AutoLogoutSettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = BackgroundLogoutMode.off.name
          ..inactivityLogoutTimeoutName = InactivityLogoutTimeout.fiveMinutes.name;
      });

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimeout.fiveMinutes);
    });

    test('Should [use defaults for missing values] and [preserve a saved false flag]', () async {
      // Arrange
      await settingsRepository.saveSettings((AutoLogoutSettingsEntity settingsEntity) {
        settingsEntity.inactivityLogoutEnabledBool = false;
      });

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await actualAutoLogoutSettingsService.getAutoLogoutSettings();

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimeout.oneMinute);
    });
  });

  group('Tests of AutoLogoutSettingsService.saveBackgroundLogoutMode()', () {
    test('Should [create a settings record] if [settings do not exist]', () async {
      // Act
      await actualAutoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);

      // Assert
      AutoLogoutSettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, true);
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, isNull);
    });

    for (BackgroundLogoutMode automaticLogoutMode in BackgroundLogoutMode.values) {
      test('Should [save ${automaticLogoutMode.name}] and [preserve inactivity settings]', () async {
        // Arrange
        BackgroundLogoutMode initialAutomaticLogoutMode = automaticLogoutMode == BackgroundLogoutMode.on
            ? BackgroundLogoutMode.off
            : BackgroundLogoutMode.on;

        await settingsRepository.saveSettings((AutoLogoutSettingsEntity settingsEntity) {
          settingsEntity
            ..inactivityLogoutEnabledBool = false
            ..backgroundLogoutModeName = initialAutomaticLogoutMode.name
            ..inactivityLogoutTimeoutName = InactivityLogoutTimeout.fiveMinutes.name;
        });

        // Act
        await actualAutoLogoutSettingsService.saveBackgroundLogoutMode(automaticLogoutMode);

        // Assert
        AutoLogoutSettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
        expect(actualSettingsEntity?.backgroundLogoutModeName, automaticLogoutMode.name);
        expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
        expect(actualSettingsEntity?.inactivityLogoutTimeoutName, InactivityLogoutTimeout.fiveMinutes.name);
      });
    }
  });

  group('Tests of AutoLogoutSettingsService.saveInactivityEnabledBool()', () {
    for (bool inactivityLogoutEnabledBool in <bool>[false, true]) {
      test('Should [save $inactivityLogoutEnabledBool] and [preserve mode and timeout]', () async {
        // Arrange
        await settingsRepository.saveSettings((AutoLogoutSettingsEntity settingsEntity) {
          settingsEntity
            ..inactivityLogoutEnabledBool = !inactivityLogoutEnabledBool
            ..backgroundLogoutModeName = BackgroundLogoutMode.off.name
            ..inactivityLogoutTimeoutName = InactivityLogoutTimeout.fiveMinutes.name;
        });

        // Act
        await actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: inactivityLogoutEnabledBool);

        // Assert
        AutoLogoutSettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
        expect(actualSettingsEntity?.inactivityLogoutEnabledBool, inactivityLogoutEnabledBool);
        expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);
        expect(actualSettingsEntity?.inactivityLogoutTimeoutName, InactivityLogoutTimeout.fiveMinutes.name);
      });
    }

    test('Should [save the default timeout] if [the saved timeout is null]', () async {
      // Arrange
      await settingsRepository.saveSettings((AutoLogoutSettingsEntity settingsEntity) {
        settingsEntity.backgroundLogoutModeName = BackgroundLogoutMode.off.name;
      });

      // Act
      await actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);

      // Assert
      AutoLogoutSettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, InactivityLogoutTimeout.oneMinute.name);
      expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);
    });
  });

  group('Tests of AutoLogoutSettingsService.saveInactivityLogoutTimeout()', () {
    for (InactivityLogoutTimeout inactivityLogoutTimeout in <InactivityLogoutTimeout>[
      InactivityLogoutTimeout.oneMinute,
      InactivityLogoutTimeout.fiveMinutes,
    ]) {
      test('Should [save ${inactivityLogoutTimeout.name}] and [preserve disabled logout switches]', () async {
        // Arrange
        InactivityLogoutTimeout initialInactivityLogoutTimeout = inactivityLogoutTimeout == InactivityLogoutTimeout.oneMinute
            ? InactivityLogoutTimeout.fiveMinutes
            : InactivityLogoutTimeout.oneMinute;

        await settingsRepository.saveSettings((AutoLogoutSettingsEntity settingsEntity) {
          settingsEntity
            ..inactivityLogoutEnabledBool = false
            ..backgroundLogoutModeName = BackgroundLogoutMode.off.name
            ..inactivityLogoutTimeoutName = initialInactivityLogoutTimeout.name;
        });

        // Act
        await actualAutoLogoutSettingsService.saveInactivityLogoutTimeout(inactivityLogoutTimeout);

        // Assert
        AutoLogoutSettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
        expect(actualSettingsEntity?.inactivityLogoutTimeoutName, inactivityLogoutTimeout.name);
        expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
        expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);
      });
    }

    test('Should [create settings with inactivity enabled] if [settings do not exist]', () async {
      // Act
      await actualAutoLogoutSettingsService.saveInactivityLogoutTimeout(InactivityLogoutTimeout.fiveMinutes);

      // Assert
      AutoLogoutSettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, InactivityLogoutTimeout.fiveMinutes.name);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, true);
      expect(actualSettingsEntity?.backgroundLogoutModeName, isNull);
    });
  });

  group('Tests of AutoLogoutSettingsService simultaneous saves', () {
    test('Should [preserve every change] when [different settings are saved simultaneously]', () async {
      // Act
      await Future.wait<void>(<Future<void>>[
        actualAutoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off),
        actualAutoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false),
        actualAutoLogoutSettingsService.saveInactivityLogoutTimeout(InactivityLogoutTimeout.fiveMinutes),
      ]);

      // Assert
      AutoLogoutSettingsEntity? actualSettingsEntity = await settingsRepository.getSettings();
      expect(actualSettingsEntity?.backgroundLogoutModeName, BackgroundLogoutMode.off.name);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, InactivityLogoutTimeout.fiveMinutes.name);
    });
  });
}
