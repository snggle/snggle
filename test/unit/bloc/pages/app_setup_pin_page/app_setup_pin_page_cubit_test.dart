import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/a_app_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/app_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_loading_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/master_key_controller.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage.setMockInitialValues(<String, String>{});
  initLocator();

  late MasterKeyController masterKeyController;
  late AppSetupPinPageCubit actualAppSetupPinPageCubit;

  group('Tests of [AppSetupPinPageCubit]', () {
    group('Tests of a successful password setting process', () {
      setUpAll(() {
        masterKeyController = MasterKeyController();
        actualAppSetupPinPageCubit = AppSetupPinPageCubit(masterKeyController: masterKeyController);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState.empty();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [FILLED firstPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState(firstPinNumbers: <int>[1, 1, 1, 1]);

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.setupFirstPin();

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageConfirmPinState(
          firstPinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[],
        );

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.updateConfirmPin(<int>[1, 1, 1, 1]);

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageConfirmPinState(
          firstPinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[1, 1, 1, 1],
        );

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageLoadingState] after confirming entered pin]', () async {
        // Act
        await actualAppSetupPinPageCubit.setupConfirmPin();

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageLoadingState();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });
    });

    group('Tests of a successful default password setting process', () {
      setUpAll(() {
        masterKeyController = MasterKeyController();
        actualAppSetupPinPageCubit = AppSetupPinPageCubit(masterKeyController: masterKeyController);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState.empty();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageLoadingState] after setting default pin', () async {
        // Act
        await actualAppSetupPinPageCubit.setupDefaultPin();

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageLoadingState();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });
    });

    group('Tests of a password setting process with wrong confirm password provided', () {
      setUpAll(() {
        masterKeyController = MasterKeyController();
        actualAppSetupPinPageCubit = AppSetupPinPageCubit(masterKeyController: masterKeyController);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState.empty();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [FILED firstPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState(firstPinNumbers: <int>[1, 1, 1, 1]);

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.setupFirstPin();

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageConfirmPinState(
          firstPinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[],
        );

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
        // Act
        actualAppSetupPinPageCubit.updateConfirmPin(<int>[9, 9, 9, 9]);

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageConfirmPinState(
          firstPinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[9, 9, 9, 9],
        );

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });

      test('Should [emit AppSetupPinPageLoadingState] after confirming entered pin', () async {
        try {
          // Act
          await actualAppSetupPinPageCubit.setupConfirmPin();
        } catch (actualException) {
          // Assert
          AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageInvalidPinState(
            firstPinNumbers: <int>[1, 1, 1, 1],
            confirmPinNumbers: <int>[9, 9, 9, 9],
          );

          expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
          expect(actualException, isA<InvalidPasswordException>());
        }
      });

      test('Should [emit AppSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] after resetting', () async {
        // Act
        actualAppSetupPinPageCubit.resetAllPins();

        // Assert
        AAppSetupPinPageState expectedAppSetupPinPageState = const AppSetupPinPageEnterPinState.empty();

        expect(actualAppSetupPinPageCubit.state, expectedAppSetupPinPageState);
      });
    });
  });
}