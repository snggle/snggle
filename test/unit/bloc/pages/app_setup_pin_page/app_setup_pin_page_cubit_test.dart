import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/a_app_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/app_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_loading_state.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage.setMockInitialValues(<String, String>{});
  initLocator();

  late AuthSingletonCubit actualAuthSingletonCubit;
  late AppSetupPinPageCubit actualAppSetupPinPageCubit;

  group('Tests of [AppSetupPinPageCubit]', () {
    group('Tests of a successful password setting process', () {
      setUpAll(() {
        actualAuthSingletonCubit = AuthSingletonCubit();
        actualAppSetupPinPageCubit = AppSetupPinPageCubit(authSingletonCubit: actualAuthSingletonCubit);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState.empty();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [FILLED basePinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.updateBasePin(const <int>[1, 1, 1, 1]);

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState(basePinNumbers: <int>[1, 1, 1, 1]);

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageConfirmPinState] with [FILLED basePinNumbers] and [EMPTY confirmPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.setupBasePin();

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageConfirmPinState(
          basePinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[],
        );

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [FILLED basePinNumbers] and [FILLED confirmPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.updateConfirmPin(<int>[1, 1, 1, 1]);

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageConfirmPinState(
          basePinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[1, 1, 1, 1],
        );

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageLoadingState] and set appPassword in [AuthSingletonCubit]', () async {
        // Act
        await actualAppSetupPinPageCubit.setupConfirmPin();
        PasswordModel actualAppPasswordModel = actualAuthSingletonCubit.currentAppPasswordModel!;

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageLoadingState();
        PasswordModel expectedAppPasswordModel = PasswordModel.fromPlaintext('1111');

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
        expect(actualAppPasswordModel, expectedAppPasswordModel);
      });
    });

    group('Tests of a successful default password setting process', () {
      setUpAll(() {
        actualAuthSingletonCubit = AuthSingletonCubit();
        actualAppSetupPinPageCubit = AppSetupPinPageCubit(authSingletonCubit: actualAuthSingletonCubit);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState.empty();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageLoadingState] and set appPassword in [AuthSingletonCubit]', () async {
        // Act
        await actualAppSetupPinPageCubit.setupDefaultPin();
        PasswordModel actualAppPasswordModel = actualAuthSingletonCubit.currentAppPasswordModel!;

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageLoadingState();
        PasswordModel expectedAppPasswordModel = PasswordModel.defaultPassword();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
        expect(actualAppPasswordModel, expectedAppPasswordModel);
      });
    });

    group('Tests of a password setting process with wrong confirm password provided', () {
      setUpAll(() {
        actualAuthSingletonCubit = AuthSingletonCubit();
        actualAppSetupPinPageCubit = AppSetupPinPageCubit(authSingletonCubit: actualAuthSingletonCubit);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState.empty();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState.empty();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [FILED basePinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.updateBasePin(const <int>[1, 1, 1, 1]);

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState(basePinNumbers: <int>[1, 1, 1, 1]);

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageConfirmPinState] with [FILLED basePinNumbers] and [EMPTY confirmPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.setupBasePin();

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageConfirmPinState(
          basePinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[],
        );

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [FILLED basePinNumbers] and [FILLED confirmPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.updateConfirmPin(<int>[9, 9, 9, 9]);

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageConfirmPinState(
          basePinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[9, 9, 9, 9],
        );

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageLoadingState] and set appPassword in [AuthSingletonCubit]', () async {
        try {
          // Act
          await actualAppSetupPinPageCubit.setupConfirmPin();
        } catch (actualException) {
          // Assert
          AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageInvalidPinState(
            basePinNumbers: <int>[1, 1, 1, 1],
            confirmPinNumbers: <int>[9, 9, 9, 9],
          );

          expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
          expect(actualException, isA<InvalidPasswordException>());
        }
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [EMPTY pinNumbers] after resetting', () async {
        // Act
        actualAppSetupPinPageCubit.resetToBasePin();

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState.empty();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });
    });
  });
}
