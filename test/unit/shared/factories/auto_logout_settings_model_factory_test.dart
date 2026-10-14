import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/shared/factories/auto_logout_settings_model_factory.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';

void main() {
  AutoLogoutSettingsModelFactory autoLogoutSettingsModelFactory = AutoLogoutSettingsModelFactory();

  group('Tests of AutoLogoutSettingsModelFactory.createFromEntity()', () {
    test('Should [return default settings] if [SettingsEntity NULL]', () {
      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(null);

      // Assert
      expect(
        actualAutoLogoutSettingsModel.inactivityLogoutBool,
        AutoLogoutSettingsModel.defaultInactivityLogoutBool,
      );
      expect(
        actualAutoLogoutSettingsModel.automaticLogoutMode,
        AutoLogoutSettingsModel.defaultAutomaticLogoutMode,
      );
      expect(
        actualAutoLogoutSettingsModel.inactivityLogoutTimeout,
        AutoLogoutSettingsModel.defaultInactivityLogoutTimeout,
      );
    });

    test('Should [use default enum values] if [stored names NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity();

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(
        actualAutoLogoutSettingsModel.automaticLogoutMode,
        AutoLogoutSettingsModel.defaultAutomaticLogoutMode,
      );
      expect(
        actualAutoLogoutSettingsModel.inactivityLogoutTimeout,
        AutoLogoutSettingsModel.defaultInactivityLogoutTimeout,
      );
    });

    test('Should [map enabled settings] with [one-minute timeout]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = true
        ..automaticLogoutModeName = 'on'
        ..inactivityLogoutTimeoutName = 'oneMinute';

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(
        actualAutoLogoutSettingsModel.automaticLogoutMode,
        AutomaticLogoutMode.on,
      );
      expect(
        actualAutoLogoutSettingsModel.inactivityLogoutTimeout,
        InactivityLogoutTimeout.oneMinute,
      );
    });

    for (bool inactivityLogoutEnabledBool in <bool>[false, true]) {
      test(
        'Should [map saved settings] if [inactivity logout $inactivityLogoutEnabledBool]',
        () {
          // Arrange
          SettingsEntity settingsEntity = SettingsEntity()
            ..inactivityLogoutEnabledBool = inactivityLogoutEnabledBool
            ..automaticLogoutModeName = 'off'
            ..inactivityLogoutTimeoutName = 'fiveMinutes';

          // Act
          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

          // Assert
          expect(
            actualAutoLogoutSettingsModel.inactivityLogoutBool,
            inactivityLogoutEnabledBool,
          );
          expect(
            actualAutoLogoutSettingsModel.automaticLogoutMode,
            AutomaticLogoutMode.off,
          );
          expect(
            actualAutoLogoutSettingsModel.inactivityLogoutTimeout,
            InactivityLogoutTimeout.fiveMinutes,
          );
        },
      );
    }

    for (String? automaticLogoutModeName in <String?>[null, '', 'invalid_mode']) {
      test(
        'Should [use default automatic logout mode] if [stored mode "$automaticLogoutModeName"]',
        () {
          // Arrange
          SettingsEntity settingsEntity = SettingsEntity()
            ..inactivityLogoutEnabledBool = false
            ..automaticLogoutModeName = automaticLogoutModeName
            ..inactivityLogoutTimeoutName = 'fiveMinutes';

          // Act
          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

          // Assert
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
          expect(
            actualAutoLogoutSettingsModel.automaticLogoutMode,
            AutoLogoutSettingsModel.defaultAutomaticLogoutMode,
          );
          expect(
            actualAutoLogoutSettingsModel.inactivityLogoutTimeout,
            InactivityLogoutTimeout.fiveMinutes,
          );
        },
      );
    }

    for (String? inactivityLogoutTimeoutName in <String?>[null, '', 'invalid_timeout']) {
      test(
        'Should [use default inactivity timeout] if [stored timeout "$inactivityLogoutTimeoutName"]',
        () {
          // Arrange
          SettingsEntity settingsEntity = SettingsEntity()
            ..inactivityLogoutEnabledBool = false
            ..automaticLogoutModeName = 'off'
            ..inactivityLogoutTimeoutName = inactivityLogoutTimeoutName;

          // Act
          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

          // Assert
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
          expect(
            actualAutoLogoutSettingsModel.automaticLogoutMode,
            AutomaticLogoutMode.off,
          );
          expect(
            actualAutoLogoutSettingsModel.inactivityLogoutTimeout,
            AutoLogoutSettingsModel.defaultInactivityLogoutTimeout,
          );
        },
      );
    }

    for (bool inactivityLogoutEnabledBool in <bool>[false, true]) {
      test(
        'Should [disable inactivity logout and restore default timeout] '
        'if [timeout OFF] and [enabled flag $inactivityLogoutEnabledBool]',
        () {
          // Arrange
          SettingsEntity settingsEntity = SettingsEntity()
            ..inactivityLogoutEnabledBool = inactivityLogoutEnabledBool
            ..automaticLogoutModeName = 'on'
            ..inactivityLogoutTimeoutName = 'off';

          // Act
          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

          // Assert
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
          expect(
            actualAutoLogoutSettingsModel.automaticLogoutMode,
            AutomaticLogoutMode.on,
          );
          expect(
            actualAutoLogoutSettingsModel.inactivityLogoutTimeout,
            AutoLogoutSettingsModel.defaultInactivityLogoutTimeout,
          );
        },
      );
    }

    test(
      'Should [leave the source entity unchanged] when normalizing stored values',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..id = 42
          ..inactivityLogoutEnabledBool = true
          ..automaticLogoutModeName = 'invalid_mode'
          ..inactivityLogoutTimeoutName = 'off';

        // Act
        autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(settingsEntity.id, 42);
        expect(settingsEntity.inactivityLogoutEnabledBool, true);
        expect(settingsEntity.automaticLogoutModeName, 'invalid_mode');
        expect(settingsEntity.inactivityLogoutTimeoutName, 'off');
      },
    );
  });
}
