import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/auto_logout_settings_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/auto_logout_settings_model.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';
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
        automaticLogoutMode: AutomaticLogoutMode.on,
        inactivityLogoutTimeout: InactivityLogoutTimeout.oneMinute,
      );

      // Assert
      expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
    });

    group('Tests of [AutoLogoutCubit.init]', () {
      test('Should [use default settings] when [settings are not saved]', () async {
        // Arrange
        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: true,
          automaticLogoutMode: AutomaticLogoutMode.on,
          inactivityLogoutTimeout: InactivityLogoutTimeout.oneMinute,
        );

        // Act
        await actualAutoLogoutCubit.init();

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
      });

      test('Should [use defaults for missing settings] when [only background mode is saved]', () async {
        // Arrange
        await autoLogoutSettingsService.saveAutomaticLogoutMode(AutomaticLogoutMode.off);

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: true,
          automaticLogoutMode: AutomaticLogoutMode.off,
          inactivityLogoutTimeout: InactivityLogoutTimeout.oneMinute,
        );

        // Act
        await actualAutoLogoutCubit.init();

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
      });

      test('Should [load saved settings] instead of [default settings]', () async {
        // Arrange
        await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
        await autoLogoutSettingsService.saveAutomaticLogoutMode(AutomaticLogoutMode.off);
        await autoLogoutSettingsService.saveInactivityLogoutTimeout(InactivityLogoutTimeout.fiveMinutes);

        const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
          inactivityLogoutEnabledBool: false,
          automaticLogoutMode: AutomaticLogoutMode.off,
          inactivityLogoutTimeout: InactivityLogoutTimeout.fiveMinutes,
        );

        // Act
        await actualAutoLogoutCubit.init();

        // Assert
        expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);
      });
    });

    group('Tests of [AutoLogoutCubit.setAutomaticLogoutMode]', () {
      for (AutomaticLogoutMode automaticLogoutMode in AutomaticLogoutMode.values) {
        test('Should [save ${automaticLogoutMode.name}] and [preserve inactivity settings]', () async {
          // Arrange
          AutomaticLogoutMode initialAutomaticLogoutMode = automaticLogoutMode == AutomaticLogoutMode.on
              ? AutomaticLogoutMode.off
              : AutomaticLogoutMode.on;

          await autoLogoutSettingsService.saveAutomaticLogoutMode(initialAutomaticLogoutMode);
          await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
          await autoLogoutSettingsService.saveInactivityLogoutTimeout(InactivityLogoutTimeout.fiveMinutes);
          await actualAutoLogoutCubit.init();

          AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
            inactivityLogoutEnabledBool: false,
            automaticLogoutMode: automaticLogoutMode,
            inactivityLogoutTimeout: InactivityLogoutTimeout.fiveMinutes,
          );

          // Act
          await actualAutoLogoutCubit.setAutomaticLogoutMode(automaticLogoutMode: automaticLogoutMode);

          // Assert
          expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

          expect(actualAutoLogoutSettingsModel.automaticLogoutMode, automaticLogoutMode);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, false);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimeout.fiveMinutes);
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
          await autoLogoutSettingsService.saveAutomaticLogoutMode(AutomaticLogoutMode.off);
          await autoLogoutSettingsService.saveInactivityLogoutTimeout(InactivityLogoutTimeout.fiveMinutes);
          await actualAutoLogoutCubit.init();

          AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
            inactivityLogoutEnabledBool: inactivityLogoutEnabledBool,
            automaticLogoutMode: AutomaticLogoutMode.off,
            inactivityLogoutTimeout: InactivityLogoutTimeout.fiveMinutes,
          );

          // Act
          await actualAutoLogoutCubit.setInactivityEnabledBool(
            inactivityLogoutEnabledBool: inactivityLogoutEnabledBool,
          );

          // Assert
          expect(actualAutoLogoutCubit.state, expectedAutoLogoutState);

          AutoLogoutSettingsModel actualAutoLogoutSettingsModel = await autoLogoutSettingsService.getAutoLogoutSettings();

          expect(actualAutoLogoutSettingsModel.inactivityLogoutBool, inactivityLogoutEnabledBool);
          expect(actualAutoLogoutSettingsModel.automaticLogoutMode, AutomaticLogoutMode.off);
          expect(actualAutoLogoutSettingsModel.inactivityLogoutTimeout, InactivityLogoutTimeout.fiveMinutes);
        });
      }
    });

    group('Tests of [AutoLogoutCubit.setInactivityLogoutTimeout]', () {
      for (InactivityLogoutTimeout inactivityLogoutTimeout in <InactivityLogoutTimeout>[
        InactivityLogoutTimeout.oneMinute,
        InactivityLogoutTimeout.fiveMinutes,
      ]) {
        test('Should [save ${inactivityLogoutTimeout.name}] and [preserve logout switches]', () async {
          // Arrange
          InactivityLogoutTimeout initialInactivityLogoutTimeout = inactivityLogoutTimeout == InactivityLogoutTimeout.oneMinute
              ? InactivityLogoutTimeout.fiveMinutes
              : InactivityLogoutTimeout.oneMinute;

          await autoLogoutSettingsService.saveInactivityLogoutTimeout(initialInactivityLogoutTimeout);
          await autoLogoutSettingsService.saveInactivityEnabledBool(inactivityLogoutEnabledBool: false);
          await autoLogoutSettingsService.saveAutomaticLogoutMode(AutomaticLogoutMode.off);
          await actualAutoLogoutCubit.init();

          AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
            inactivityLogoutEnabledBool: false,
            automaticLogoutMode: AutomaticLogoutMode.off,
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
          expect(actualAutoLogoutSettingsModel.automaticLogoutMode, AutomaticLogoutMode.off);
        });
      }
    });

    test('Should [restore changed settings] in [a new Cubit instance]', () async {
      // Arrange
      await actualAutoLogoutCubit.setAutomaticLogoutMode(automaticLogoutMode: AutomaticLogoutMode.off);
      await actualAutoLogoutCubit.setInactivityEnabledBool(inactivityLogoutEnabledBool: false);
      await actualAutoLogoutCubit.setInactivityLogoutTimeout(
        inactivityLogoutTimeout: InactivityLogoutTimeout.fiveMinutes,
      );

      AutoLogoutCubit restoredAutoLogoutCubit = AutoLogoutCubit();
      addTearDown(restoredAutoLogoutCubit.close);

      const AutoLogoutState expectedAutoLogoutState = AutoLogoutState(
        inactivityLogoutEnabledBool: false,
        automaticLogoutMode: AutomaticLogoutMode.off,
        inactivityLogoutTimeout: InactivityLogoutTimeout.fiveMinutes,
      );

      // Act
      await restoredAutoLogoutCubit.init();

      // Assert
      expect(restoredAutoLogoutCubit.state, expectedAutoLogoutState);
    });
  });
}
