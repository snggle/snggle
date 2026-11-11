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

    test('Should [use default settings] if [stored enums NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity();

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
    });

    test('Should [map enabled settings] with [one-minute timer]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutMode = BackgroundLogoutMode.on
        ..inactivityLogoutTimer = InactivityLogoutTimer.oneMinute;

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.oneMinute);
    });

    test('Should [map saved settings] if [inactivity logout disabled]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = false
        ..backgroundLogoutMode = BackgroundLogoutMode.off
        ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [map saved settings] if [inactivity logout enabled]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutMode = BackgroundLogoutMode.off
        ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [use default background logout mode] if [stored mode NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = false
        ..backgroundLogoutMode = null
        ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, AutoLogoutSettingsModel.defaultBackgroundLogoutMode);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [use default inactivity timer] and [preserve disabled flag] if [stored timer NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = false
        ..backgroundLogoutMode = BackgroundLogoutMode.off
        ..inactivityLogoutTimer = null;

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
    });

    test('Should [use default inactivity timer] and [preserve enabled flag] if [stored timer NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutMode = BackgroundLogoutMode.off
        ..inactivityLogoutTimer = null;

      // Act
      AutoLogoutSettingsModel actualAutoLogoutSettingsModel = autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
      expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, AutoLogoutSettingsModel.defaultInactivityLogoutTimer);
    });

    test('Should [leave the source entity unchanged] when applying default values', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..id = 42
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutMode = null
        ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;

      // Act
      autoLogoutSettingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(settingsEntity.id, 42);
      expect(settingsEntity.inactivityLogoutEnabledBool, true);
      expect(settingsEntity.backgroundLogoutMode, isNull);
      expect(settingsEntity.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });
  });
}