import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/infra/repositories/settings_repository.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late SettingsRepository actualSettingsRepository;

  setUp(() async {
    testDatabase = TestDatabase();
    await testDatabase.init(
      databaseMock: DatabaseMock.emptyDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );

    actualSettingsRepository = globalLocator<SettingsRepository>();
  });

  tearDown(() async {
    await testDatabase.close();
  });

  group('Tests of SettingsRepository.getSettings()', () {
    test('Should [return null] if [settings do not exist]', () async {
      // Act
      SettingsEntity? actualSettingsEntity = await actualSettingsRepository.getSettings();

      // Assert
      expect(actualSettingsEntity, isNull);
    });

    test('Should [return saved settings] from [a new repository instance]', () async {
      // Arrange
      await actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..automaticLogoutModeName = 'off'
          ..inactivityLogoutTimeoutName = 'fiveMinutes';
      });

      SettingsRepository restoredSettingsRepository = SettingsRepository();

      // Act
      SettingsEntity? actualSettingsEntity = await restoredSettingsRepository.getSettings();

      // Assert
      expect(actualSettingsEntity?.id, SettingsEntity.settingsId);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.automaticLogoutModeName, 'off');
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, 'fiveMinutes');
    });
  });

  group('Tests of SettingsRepository.saveSettings()', () {
    test('Should [create settings with the fixed ID] if [settings do not exist]', () async {
      // Act
      await actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..automaticLogoutModeName = 'off'
          ..inactivityLogoutTimeoutName = 'fiveMinutes';
      });

      // Assert
      SettingsEntity? actualSettingsEntity = await actualSettingsRepository.getSettings();
      expect(actualSettingsEntity?.id, SettingsEntity.settingsId);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.automaticLogoutModeName, 'off');
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, 'fiveMinutes');
    });

    test('Should [preserve entity defaults] when [only one field is initially saved]', () async {
      // Act
      await actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity.automaticLogoutModeName = 'off';
      });

      // Assert
      SettingsEntity? actualSettingsEntity = await actualSettingsRepository.getSettings();
      expect(actualSettingsEntity?.id, SettingsEntity.settingsId);
      expect(actualSettingsEntity?.automaticLogoutModeName, 'off');
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, true);
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, isNull);
    });

    test('Should [update existing settings] and [preserve untouched fields]', () async {
      // Arrange
      await actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..automaticLogoutModeName = 'on'
          ..inactivityLogoutTimeoutName = 'fiveMinutes';
      });

      // Act
      await actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity.automaticLogoutModeName = 'off';
      });

      // Assert
      SettingsEntity? actualSettingsEntity = await actualSettingsRepository.getSettings();
      expect(actualSettingsEntity?.id, SettingsEntity.settingsId);
      expect(actualSettingsEntity?.automaticLogoutModeName, 'off');
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, 'fiveMinutes');
    });

    test('Should [preserve every change] when [different fields are saved simultaneously]', () async {
      // Act
      await Future.wait<void>(<Future<void>>[
        actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
          settingsEntity.inactivityLogoutEnabledBool = false;
        }),
        actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
          settingsEntity.automaticLogoutModeName = 'off';
        }),
        actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
          settingsEntity.inactivityLogoutTimeoutName = 'fiveMinutes';
        }),
      ]);

      // Assert
      SettingsEntity? actualSettingsEntity = await actualSettingsRepository.getSettings();
      expect(actualSettingsEntity?.id, SettingsEntity.settingsId);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.automaticLogoutModeName, 'off');
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, 'fiveMinutes');
    });

    test('Should [propagate the exception without creating settings] if [the callback throws]', () async {
      // Arrange
      Exception expectedException = Exception('Settings update failed.');

      // Act / Assert
      await expectLater(
            () => actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
          settingsEntity.automaticLogoutModeName = 'off';
          throw expectedException;
        }),
        throwsA(same(expectedException)),
      );

      expect(await actualSettingsRepository.getSettings(), isNull);
    });

    test('Should [propagate the exception and preserve saved settings] if [the callback throws]', () async {
      // Arrange
      await actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
        settingsEntity
          ..inactivityLogoutEnabledBool = false
          ..automaticLogoutModeName = 'off'
          ..inactivityLogoutTimeoutName = 'fiveMinutes';
      });

      Exception expectedException = Exception('Settings update failed.');

      // Act / Assert
      await expectLater(
            () => actualSettingsRepository.saveSettings((SettingsEntity settingsEntity) {
          settingsEntity
            ..inactivityLogoutEnabledBool = true
            ..automaticLogoutModeName = 'on'
            ..inactivityLogoutTimeoutName = 'oneMinute';
          throw expectedException;
        }),
        throwsA(same(expectedException)),
      );

      SettingsEntity? actualSettingsEntity = await actualSettingsRepository.getSettings();
      expect(actualSettingsEntity?.id, SettingsEntity.settingsId);
      expect(actualSettingsEntity?.inactivityLogoutEnabledBool, false);
      expect(actualSettingsEntity?.automaticLogoutModeName, 'off');
      expect(actualSettingsEntity?.inactivityLogoutTimeoutName, 'fiveMinutes');
    });
  });
}