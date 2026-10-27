import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/auto_logout_settings_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../../../../utils/database_mock.dart';
import '../../../../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late AutoLogoutCubit actualAutoLogoutCubit;
  late AutoLogoutSettingsService autoLogoutSettingsService;

  group('Tests of [AutoLogoutCubit]', () {
    setUp(() async {
      testDatabase = TestDatabase();
      await testDatabase.init(
        databaseMock: DatabaseMock.emptyDatabaseMock,
        appPasswordModel: PasswordModel.defaultPassword(),
      );

      autoLogoutSettingsService = globalLocator<AutoLogoutSettingsService>();
      actualAutoLogoutCubit = AutoLogoutCubit();
    });

    tearDown(() async {
      await actualAutoLogoutCubit.close();
      await Future<void>.sync(testDatabase.close);
    });

    test('Should [use default settings] as initial state', () {
      // Arrange
      const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
        inactivityLogoutEnabledBool: true,
        backgroundLogoutMode: BackgroundLogoutMode.on,
        inactivityLogoutTimeout: InactivityLogoutTimer.oneMinute,
      );

      // Assert
      expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
    });

    group('Tests of [AutoLogoutCubit.init]', () {
      test('Should [use default settings] when [settings are not saved]', () async {
        // Arrange
        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: true,
          backgroundLogoutMode: BackgroundLogoutMode.on,
          inactivityLogoutTimeout: InactivityLogoutTimer.oneMinute,
        );

        // Act
        await actualAutoLogoutCubit.init();

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
      });

      test('Should [use defaults for missing settings] when [only background mode is saved]', () async {
        // Arrange
        await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: true,
          backgroundLogoutMode: BackgroundLogoutMode.off,
          inactivityLogoutTimeout: InactivityLogoutTimer.oneMinute,
        );

        // Act
        await actualAutoLogoutCubit.init();

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
      });

      test('Should [load saved settings] instead of [default settings]', () async {
        // Arrange
        await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
        await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);
        await autoLogoutSettingsService.saveInactivityLogoutTimeout(InactivityLogoutTimer.fiveMinutes);

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: false,
          backgroundLogoutMode: BackgroundLogoutMode.off,
          inactivityLogoutTimeout: InactivityLogoutTimer.fiveMinutes,
        );

        // Act
        await actualAutoLogoutCubit.init();

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
      });
    });

    group('Tests of [AutoLogoutCubit.setAutomaticLogoutMode]', () {
      for (BackgroundLogoutMode backgroundLogoutMode in BackgroundLogoutMode.values) {
        test('Should [save ${backgroundLogoutMode.name}] and [preserve inactivity settings]', () async {
          // Arrange
          BackgroundLogoutMode initialAutomaticLogoutMode = backgroundLogoutMode == BackgroundLogoutMode.on
              ? BackgroundLogoutMode.off
              : BackgroundLogoutMode.on;

          await autoLogoutSettingsService.saveBackgroundLogoutMode(initialAutomaticLogoutMode);
          await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
          await autoLogoutSettingsService.saveInactivityLogoutTimeout(InactivityLogoutTimer.fiveMinutes);
          await actualAutoLogoutCubit.init();

          AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
            inactivityLogoutEnabledBool: false,
            backgroundLogoutMode: backgroundLogoutMode,
            inactivityLogoutTimeout: InactivityLogoutTimer.fiveMinutes,
          );

          // Act
          await actualAutoLogoutCubit.setBackgroundLogoutMode(backgroundLogoutMode: backgroundLogoutMode);

          // Assert
          expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

          expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, backgroundLogoutMode);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimer.fiveMinutes);
        });
      }
    });

    group('Tests of [AutoLogoutCubit.setInactivityEnabledBool]', () {
      for (bool inactivityLogoutEnabledBool in <bool>[false, true]) {
        test('Should [save $inactivityLogoutEnabledBool] and [preserve mode and timeout]', () async {
          // Arrange
          await autoLogoutSettingsService.saveInactivityEnabledBool(
            inactivityLogoutEnabledBool: !inactivityLogoutEnabledBool,
          );
          await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);
          await autoLogoutSettingsService.saveInactivityLogoutTimeout(InactivityLogoutTimer.fiveMinutes);
          await actualAutoLogoutCubit.init();

          AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
            inactivityLogoutEnabledBool: inactivityLogoutEnabledBool,
            backgroundLogoutMode: BackgroundLogoutMode.off,
            inactivityLogoutTimeout: InactivityLogoutTimer.fiveMinutes,
          );

          // Act
          await actualAutoLogoutCubit.setInactivityEnabled(
            inactivityLogoutEnabledBool: inactivityLogoutEnabledBool,
          );

          // Assert
          expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, inactivityLogoutEnabledBool);
          expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimer.fiveMinutes);
        });
      }
    });

    group('Tests of [AutoLogoutCubit.setInactivityLogoutTimeout]', () {
      for (InactivityLogoutTimer inactivityLogoutTimeout in <InactivityLogoutTimer>[
        InactivityLogoutTimer.oneMinute,
        InactivityLogoutTimer.fiveMinutes,
      ]) {
        test('Should [save ${inactivityLogoutTimeout.name}] and [preserve logout switches]', () async {
          // Arrange
          InactivityLogoutTimer initialInactivityLogoutTimeout = inactivityLogoutTimeout == InactivityLogoutTimer.oneMinute
              ? InactivityLogoutTimer.fiveMinutes
              : InactivityLogoutTimer.oneMinute;

          await autoLogoutSettingsService.saveInactivityLogoutTimeout(initialInactivityLogoutTimeout);
          await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
          await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);
          await actualAutoLogoutCubit.init();

          AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
            inactivityLogoutEnabledBool: false,
            backgroundLogoutMode: BackgroundLogoutMode.off,
            inactivityLogoutTimeout: inactivityLogoutTimeout,
          );

          // Act
          await actualAutoLogoutCubit.setInactivityLogoutTimeout(
            inactivityLogoutTimeout: inactivityLogoutTimeout,
          );

          // Assert
          expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

          expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, inactivityLogoutTimeout);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
          expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        });
      }
    });

    test('Should [restore changed settings] in [a new Cubit instance]', () async {
      // Arrange
      await actualAutoLogoutCubit.setBackgroundLogoutMode(backgroundLogoutMode: BackgroundLogoutMode.off);
      await actualAutoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: false);
      await actualAutoLogoutCubit.setInactivityLogoutTimeout(
        inactivityLogoutTimeout: InactivityLogoutTimer.fiveMinutes,
      );

      AutoLogoutCubit restoredAutoLogoutCubit = AutoLogoutCubit();
      addTearDown(restoredAutoLogoutCubit.close);

      const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
        inactivityLogoutEnabledBool: false,
        backgroundLogoutMode: BackgroundLogoutMode.off,
        inactivityLogoutTimeout: InactivityLogoutTimer.fiveMinutes,
      );

      // Act
      await restoredAutoLogoutCubit.init();

      // Assert
      expect(restoredAutoLogoutCubit.state, expectedAutoLogoutState);
    });
  });
}
