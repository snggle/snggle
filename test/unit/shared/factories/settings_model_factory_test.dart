import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/infra/entities/settings_entity/settings_entity.dart';
import 'package:snggle/shared/factories/settings_model_factory.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
import 'package:snggle/shared/models/auto_logout_settings/settings_model.dart';

void main() {
  SettingsModelFactory settingsModelFactory = SettingsModelFactory();

  group('Tests of SettingsModelFactory.createFromEntity()', () {
    test('Should [return default settings] if [SettingsEntity NULL]', () {
      // Act
      SettingsModel actualSettingsModel = settingsModelFactory.createFromEntity(null);

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, SettingsModel.defaultInactivityLogoutBool);
      expect(actualSettingsModel.backgroundLogoutMode, SettingsModel.defaultBackgroundLogoutMode);
      expect(actualSettingsModel.inactivityLogoutTimer, SettingsModel.defaultInactivityLogoutTimer);
    });

    test('Should [use default settings] if [stored enums NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity();

      // Act
      SettingsModel actualSettingsModel = settingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, false);
      expect(actualSettingsModel.backgroundLogoutMode, SettingsModel.defaultBackgroundLogoutMode);
      expect(actualSettingsModel.inactivityLogoutTimer, SettingsModel.defaultInactivityLogoutTimer);
    });

    test('Should [map enabled settings] with [one-minute timer]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutMode = BackgroundLogoutMode.on
        ..inactivityLogoutTimer = InactivityLogoutTimer.oneMinute;

      // Act
      SettingsModel actualSettingsModel = settingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, true);
      expect(actualSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
      expect(actualSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.oneMinute);
    });

    test('Should [map saved settings] if [inactivity logout disabled]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = false
        ..backgroundLogoutMode = BackgroundLogoutMode.off
        ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;

      // Act
      SettingsModel actualSettingsModel = settingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, false);
      expect(actualSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [map saved settings] if [inactivity logout enabled]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutMode = BackgroundLogoutMode.off
        ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;

      // Act
      SettingsModel actualSettingsModel = settingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, true);
      expect(actualSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [use default background logout mode] if [stored mode NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = false
        ..backgroundLogoutMode = null
        ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;

      // Act
      SettingsModel actuaSettingsModel = settingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actuaSettingsModel.inactivityLogoutBool, false);
      expect(actuaSettingsModel.backgroundLogoutMode, SettingsModel.defaultBackgroundLogoutMode);
      expect(actuaSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });

    test('Should [use default inactivity timer] and [preserve disabled flag] if [stored timer NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = false
        ..backgroundLogoutMode = BackgroundLogoutMode.off
        ..inactivityLogoutTimer = null;

      // Act
      SettingsModel actualSettingsModel = settingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, false);
      expect(actualSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsModel.inactivityLogoutTimer, SettingsModel.defaultInactivityLogoutTimer);
    });

    test('Should [use default inactivity timer] and [preserve enabled flag] if [stored timer NULL]', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutMode = BackgroundLogoutMode.off
        ..inactivityLogoutTimer = null;

      // Act
      SettingsModel actualSettingsModel = settingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(actualSettingsModel.inactivityLogoutBool, true);
      expect(actualSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      expect(actualSettingsModel.inactivityLogoutTimer, SettingsModel.defaultInactivityLogoutTimer);
    });

    test('Should [leave the source entity unchanged] when applying default values', () {
      // Arrange
      SettingsEntity settingsEntity = SettingsEntity()
        ..id = 42
        ..inactivityLogoutEnabledBool = true
        ..backgroundLogoutMode = null
        ..inactivityLogoutTimer = InactivityLogoutTimer.fiveMinutes;

      // Act
      settingsModelFactory.createFromEntity(settingsEntity);

      // Assert
      expect(settingsEntity.id, 42);
      expect(settingsEntity.inactivityLogoutEnabledBool, true);
      expect(settingsEntity.backgroundLogoutMode, isNull);
      expect(settingsEntity.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
    });
  });
}
