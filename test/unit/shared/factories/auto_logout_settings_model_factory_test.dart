import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/entities/auto_logout_settings_entity/auto_logout_settings_entity.dart';
import 'package:snggle/shared/factories/auto_logout_settings_model_factory.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';

void main() {
  AutoLogoutSettingsModelFactory autoLogoutSettingsModelFactory = AutoLogoutSettingsModelFactory();

  group('Tests of AutoLogoutSettingsModelFactory.createFromEntity()', () {
    test('Should [return default settings] if [SettingsEntity NULL]', () {
      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(null);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, AutoLogoutSettingsModel.defaultInactivityLogoutBool);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, AutoLogoutSettingsModel.defaultInactivityLogoutTimeout);
    });

    test('Should [use default enum values] if [stored names NULL]', () {
      // Arrange
      AutoLogoutSettingsEntity settingsEntity = AutoLogoutSettingsEntity();

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, AutoLogoutSettingsModel.defaultInactivityLogoutTimeout);
    });

    test('Should [map enabled settings] with [one-minute timeout]', () {
      // Arrange
      AutoLogoutSettingsEntity settingsEntity = AutoLogoutSettingsEntity()
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutModeName = 'on'
        ..inactivityLogoutTimeoutName = 'oneMinute';

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimeout.oneMinute);
    });

    for (bool inactivityLogoutEnabledBool in <bool>[false, true]) {
      test(
        'Should [map saved settings] if [inactivity logout $inactivityLogoutEnabledBool]',
        () {
          // Arrange
          AutoLogoutSettingsEntity settingsEntity = AutoLogoutSettingsEntity()
            ..inactivityLogoutEnabledBool = inactivityLogoutEnabledBool
            ..backgroundLogoutModeName = 'off'
            ..inactivityLogoutTimeoutName = 'fiveMinutes';

          // Act
          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

          // Assert
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, inactivityLogoutEnabledBool);
          expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimeout.fiveMinutes);
        },
      );
    }

    for (String? backgroundLogoutModeName in <String?>[null, '', 'invalid_mode']) {
      test(
        'Should [use default background logout mode] if [stored mode "$backgroundLogoutModeName"]',
        () {
          // Arrange
          AutoLogoutSettingsEntity settingsEntity = AutoLogoutSettingsEntity()
            ..inactivityLogoutEnabledBool = false
            ..backgroundLogoutModeName = backgroundLogoutModeName
            ..inactivityLogoutTimeoutName = 'fiveMinutes';

          // Act
          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

          // Assert
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
          expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimeout.fiveMinutes);
        },
      );
    }

    for (String? inactivityLogoutTimeoutName in <String?>[null, '', 'invalid_timeout']) {
      test(
        'Should [use default inactivity timeout] if [stored timeout "$inactivityLogoutTimeoutName"]',
        () {
          // Arrange
          AutoLogoutSettingsEntity settingsEntity = AutoLogoutSettingsEntity()
            ..inactivityLogoutEnabledBool = false
            ..backgroundLogoutModeName = 'off'
            ..inactivityLogoutTimeoutName = inactivityLogoutTimeoutName;

          // Act
          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

          // Assert
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
          expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, AutoLogoutSettingsModel.defaultInactivityLogoutTimeout);
        },
      );
    }

    for (bool inactivityLogoutEnabledBool in <bool>[false, true]) {
      test(
        'Should [disable inactivity logout and restore default timeout] '
        'if [timeout OFF] and [enabled flag $inactivityLogoutEnabledBool]',
        () {
          // Arrange
          AutoLogoutSettingsEntity settingsEntity = AutoLogoutSettingsEntity()
            ..inactivityLogoutEnabledBool = inactivityLogoutEnabledBool
            ..backgroundLogoutModeName = 'on'
            ..inactivityLogoutTimeoutName = 'off';

          // Act
          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

          // Assert
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
          expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, AutoLogoutSettingsModel.defaultInactivityLogoutTimeout);
        },
      );
    }

    test(
      'Should [leave the source entity unchanged] when normalizing stored values',
      () {
        // Arrange
        AutoLogoutSettingsEntity settingsEntity = AutoLogoutSettingsEntity()
          ..id = 42
          ..inactivityLogoutEnabledBool = true
          ..backgroundLogoutModeName = 'invalid_mode'
          ..inactivityLogoutTimeoutName = 'off';

        // Act
        autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

        // Assert
        expect(settingsEntity.id, 42);
        expect(settingsEntity.inactivityLogoutEnabledBool, true);
        expect(settingsEntity.backgroundLogoutModeName, 'invalid_mode');
        expect(settingsEntity.inactivityLogoutTimeoutName, 'off');
      },
    );
  });
}
