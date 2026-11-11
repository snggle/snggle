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
        inactivityLogoutEnabledBool: false,
        backgroundLogoutMode: BackgroundLogoutMode.on,
        inactivityLogoutTimer: InactivityLogoutTimer.oneMinute,
      );

      // Assert
      expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
    });

    group('Tests of [AutoLogoutCubit.init]', () {
      test('Should [use default settings] when [settings are not saved]', () async {
        // Arrange
        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: false,
          backgroundLogoutMode: BackgroundLogoutMode.on,
          inactivityLogoutTimer: InactivityLogoutTimer.oneMinute,
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
          inactivityLogoutEnabledBool: false,
          backgroundLogoutMode: BackgroundLogoutMode.off,
          inactivityLogoutTimer: InactivityLogoutTimer.oneMinute,
        );

        // Act
        await actualAutoLogoutCubit.init();

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
      });

      test('Should [load saved settings] instead of [default settings]', () async {
        // Arrange
        await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: true);
        await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);
        await autoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: true,
          backgroundLogoutMode: BackgroundLogoutMode.off,
          inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes,
        );

        // Act
        await actualAutoLogoutCubit.init();

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
      });
    });

    group('Tests of [AutoLogoutCubit.setBackgroundLogoutMode]', () {
      test('Should [save on] and [preserve inactivity settings]', () async {
        // Arrange
        await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);
        await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
        await autoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);
        await actualAutoLogoutCubit.init();

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: false,
          backgroundLogoutMode: BackgroundLogoutMode.on,
          inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes,
        );

        // Act
        await actualAutoLogoutCubit.setBackgroundLogoutMode(backgroundLogoutMode: BackgroundLogoutMode.on);

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.on);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      });

      test('Should [save off] and [preserve inactivity settings]', () async {
        // Arrange
        await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.on);
        await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
        await autoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);
        await actualAutoLogoutCubit.init();

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: false,
          backgroundLogoutMode: BackgroundLogoutMode.off,
          inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes,
        );

        // Act
        await actualAutoLogoutCubit.setBackgroundLogoutMode(backgroundLogoutMode: BackgroundLogoutMode.off);

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      });
    });

    group('Tests of [AutoLogoutCubit.setInactivityEnabled]', () {
      test('Should [save false] and [preserve mode and timeout]', () async {
        // Arrange
        await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: true);
        await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);
        await autoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);
        await actualAutoLogoutCubit.init();

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: false,
          backgroundLogoutMode: BackgroundLogoutMode.off,
          inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes,
        );

        // Act
        await actualAutoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: false);

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      });

      test('Should [save true] and [preserve mode and timeout]', () async {
        // Arrange
        await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
        await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);
        await autoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);
        await actualAutoLogoutCubit.init();

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: true,
          backgroundLogoutMode: BackgroundLogoutMode.off,
          inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes,
        );

        // Act
        await actualAutoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: true);

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, true);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
      });
    });

    group('Tests of [AutoLogoutCubit.setInactivityLogoutTimer]', () {
      test('Should [save oneMinute] and [preserve logout switches]', () async {
        // Arrange
        await autoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.fiveMinutes);
        await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
        await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);
        await actualAutoLogoutCubit.init();

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: false,
          backgroundLogoutMode: BackgroundLogoutMode.off,
          inactivityLogoutTimer: InactivityLogoutTimer.oneMinute,
        );

        // Act
        await actualAutoLogoutCubit.setInactivityLogoutTimer(inactivityLogoutTimer: InactivityLogoutTimer.oneMinute);

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.oneMinute);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      });

      test('Should [save fiveMinutes] and [preserve logout switches]', () async {
        // Arrange
        await autoLogoutSettingsService.saveInactivityLogoutTimer(InactivityLogoutTimer.oneMinute);
        await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
        await autoLogoutSettingsService.saveBackgroundLogoutMode(BackgroundLogoutMode.off);
        await actualAutoLogoutCubit.init();

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: false,
          backgroundLogoutMode: BackgroundLogoutMode.off,
          inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes,
        );

        // Act
        await actualAutoLogoutCubit.setInactivityLogoutTimer(inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes);

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

        AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

        expect(actualAutoLogoutSettingsModel.inactivityLogoutTimer, InactivityLogoutTimer.fiveMinutes);
        expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
        expect(actualAutoLogoutSettingsModel.backgroundLogoutMode, BackgroundLogoutMode.off);
      });
    });

    test('Should [restore changed settings] in [a new Cubit instance]', () async {
      // Arrange
      await actualAutoLogoutCubit.setBackgroundLogoutMode(backgroundLogoutMode: BackgroundLogoutMode.off);
      await actualAutoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: false);
      await actualAutoLogoutCubit.setInactivityLogoutTimer(inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes);

      AutoLogoutCubit restoredAutoLogoutCubit = AutoLogoutCubit();
      addTearDown(restoredAutoLogoutCubit.close);

      const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
        inactivityLogoutEnabledBool: false,
        backgroundLogoutMode: BackgroundLogoutMode.off,
        inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes,
      );

      // Act
      await restoredAutoLogoutCubit.init();

      // Assert
      expect(restoredAutoLogoutCubit.state, expectedAutoLogoutState);
    });
  });
}