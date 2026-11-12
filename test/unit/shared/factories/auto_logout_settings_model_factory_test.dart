import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/shared/factories/auto_logout_settings_model_factory.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';

void main() {
  AutoLogoutSettingsModelFactory autoLogoutSettingsModelFactory = AutoLogoutSettingsModelFactory();

  group('Tests of AutoLogoutSettingsModelFactory.createFromEntity()', () {
    test('Should [return default settings] if [SettingsEntity NULL]', () {
      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(null);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, AutoLogoutSettingsModel.defaultInactivityLogoutBool);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
    });

    test('Should [use default settings] if [stored names NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity();

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
    });

    test('Should [map enabled settings] with [one-minute timeout]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutModeName = 'on'
        ..inactivityLogoutTimerName = 'oneMinute';

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.oneMinute);
    });

    test(
      'Should [map saved settings] if [inactivity logout false]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = 'fiveMinutes';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      },
    );

    test(
      'Should [map saved settings] if [inactivity logout true]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = true
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = 'fiveMinutes';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      },
    );

    test(
      'Should [use default background logout mode] if [stored mode "null"]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = null
          ..inactivityLogoutTimerName = 'fiveMinutes';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      },
    );

    test(
      'Should [use default background logout mode] if [stored mode ""]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = ''
          ..inactivityLogoutTimerName = 'fiveMinutes';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      },
    );

    test(
      'Should [use default background logout mode] if [stored mode "invalid_mode"]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = 'invalid_mode'
          ..inactivityLogoutTimerName = 'fiveMinutes';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      },
    );

    test(
      'Should [use default inactivity timer] and [preserve enabled flag false] if [stored timeout "null"]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = null;

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
      },
    );

    test(
      'Should [use default inactivity timer] and [preserve enabled flag true] if [stored timeout "null"]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = true
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = null;

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
      },
    );

    test(
      'Should [use default inactivity timer] and [preserve enabled flag false] if [stored timeout ""]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = '';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
      },
    );

    test(
      'Should [use default inactivity timer] and [preserve enabled flag true] if [stored timeout ""]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = true
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = '';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
      },
    );

    test(
      'Should [use default inactivity timer] and [preserve enabled flag false] if [stored timeout "invalid_timeout"]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = 'invalid_timeout';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
      },
    );

    test(
      'Should [use default inactivity timer] and [preserve enabled flag true] if [stored timeout "invalid_timeout"]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = true
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = 'invalid_timeout';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
      },
    );

    test(
      'Should [use default inactivity timer] and [preserve enabled flag false] if [stored timeout "off"]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = false
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = 'off';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
      },
    );

    test(
      'Should [use default inactivity timer] and [preserve enabled flag true] if [stored timeout "off"]',
      () {
        // Arrange
        SettingsEntity settingsEntity = SettingsEntity()
          ..inactivityLogoutEnabledBool = true
          ..backgroundLogoutModeName = 'off'
          ..inactivityLogoutTimerName = 'off';

        // Act
        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
      },
    );

    test('Should [leave the source entity unchanged] when applying default values', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..id = 42
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutModeName = 'invalid_mode'
        ..inactivityLogoutTimerName = 'off';

      // Act
      autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(settingsEntity.id, 42);
      expect(settingsEntity.inactivityLogoutEnabledBool, true);
      expect(settingsEntity.backgroundLogoutModeName, 'invalid_mode');
      expect(settingsEntity.inactivityLogoutTimerName, 'off');
    });
  });
}
