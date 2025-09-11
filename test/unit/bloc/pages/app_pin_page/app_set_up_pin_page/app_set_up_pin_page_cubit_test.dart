import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/a_app_set_up_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/app_set_up_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_loading_state.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

Future<void> main() async {
  final TestDatabase testDatabase = TestDatabase();
  late AppSetUpPinPageCubit actualAppSetUpPinPageCubit;

  group('Tests of [AppSetUpPinPageCubit]', () {
    group('Tests of a successful password setting process', () {
      setUpAll(() async {
        await testDatabase.init(
          databaseMock: DatabaseMock.emptyDatabaseMock,
          appPasswordModel: PasswordModel.defaultPassword(),
        );
        actualAppSetUpPinPageCubit = AppSetUpPinPageCubit(appPinType: AppPinType.setUpPin);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageEnterPinState.empty();

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [FILLED firstPinNumbers]', () async {
        // Act
        actualAppSetUpPinPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageEnterPinState(firstPinNumbers: <int>[1, 1, 1, 1]);

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      test('Should [emit AppSetUpPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
        // Act
        actualAppSetUpPinPageCubit.setUpFirstPin();

        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageConfirmPinState(
          firstPinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[],
        );

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
        // Act
        actualAppSetUpPinPageCubit.updateConfirmPin(<int>[1, 1, 1, 1]);

        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageConfirmPinState(
          firstPinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[1, 1, 1, 1],
        );

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      test('Should [emit AppSetUpPinPageLoadingState] after confirming entered pin]', () async {
        // Act
        await actualAppSetUpPinPageCubit.setUpConfirmPin();

        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageLoadingState();

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      tearDownAll(testDatabase.close);
    });

    group('Tests of a successful default password setting process', () {
      setUpAll(() async {
        await testDatabase.init(
          databaseMock: DatabaseMock.emptyDatabaseMock,
          appPasswordModel: PasswordModel.defaultPassword(),
        );
        actualAppSetUpPinPageCubit = AppSetUpPinPageCubit(appPinType: AppPinType.setUpPin);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageEnterPinState.empty();

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      tearDownAll(testDatabase.close);
    });

    group('Tests of a password setting process with wrong confirm password provided', () {
      setUpAll(() async {
        await testDatabase.init(
          databaseMock: DatabaseMock.emptyDatabaseMock,
          appPasswordModel: PasswordModel.defaultPassword(),
        );
        actualAppSetUpPinPageCubit = AppSetUpPinPageCubit(appPinType: AppPinType.setUpPin);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageEnterPinState.empty();

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [FILED firstPinNumbers]', () async {
        // Act
        actualAppSetUpPinPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageEnterPinState(firstPinNumbers: <int>[1, 1, 1, 1]);

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      test('Should [emit AppSetUpPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
        // Act
        actualAppSetUpPinPageCubit.setUpFirstPin();

        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageConfirmPinState(
          firstPinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[],
        );

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
        // Act
        actualAppSetUpPinPageCubit.updateConfirmPin(<int>[9, 9, 9, 9]);

        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageConfirmPinState(
          firstPinNumbers: <int>[1, 1, 1, 1],
          confirmPinNumbers: <int>[9, 9, 9, 9],
        );

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      test('Should [emit AppSetUpPinPageLoadingState] after confirming entered pin', () async {
        try {
          // Act
          await actualAppSetUpPinPageCubit.setUpConfirmPin();
        } catch (actualException) {
          // Assert
          AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageInvalidPinState(
            firstPinNumbers: <int>[1, 1, 1, 1],
            confirmPinNumbers: <int>[9, 9, 9, 9],
          );

          expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
          expect(actualException, isA<InvalidPasswordException>());
        }
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [EMPTY firstPinNumbers] after resetting', () async {
        // Act
        actualAppSetUpPinPageCubit.resetAllPins();

        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageEnterPinState.empty();

        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      tearDownAll(testDatabase.close);
    });

    group('Tests of a successful PIN change process', () {
      setUpAll(() async {
        await testDatabase.init(
          databaseMock: DatabaseMock.emptyDatabaseMock,
          appPasswordModel: PasswordModel.defaultPassword(),
        );

        AppSetUpPinPageCubit setupCubit = AppSetUpPinPageCubit(appPinType: AppPinType.setUpPin)
          ..updateFirstPin(const <int>[1, 1, 1, 1])
          ..setUpFirstPin()
          ..updateConfirmPin(<int>[1, 1, 1, 1]);
        await setupCubit.setUpConfirmPin();
        await setupCubit.close();

        actualAppSetUpPinPageCubit = AppSetUpPinPageCubit(appPinType: AppPinType.changePin)
          ..updateFirstPin(const <int>[2, 2, 2, 2])
          ..setUpFirstPin()
          ..updateConfirmPin(<int>[2, 2, 2, 2]);
      });

      test('Should [emit AppSetUpPinPageLoadingState] after confirming entered pin', () async {
        // Act
        await actualAppSetUpPinPageCubit.setUpConfirmPin();

        // Assert
        AAppSetUpPinPageState expectedAppSetUpPinPageState = const AppSetUpPinPageLoadingState();
        expect(actualAppSetUpPinPageCubit.state, expectedAppSetUpPinPageState);
      });

      tearDownAll(() async {
        await actualAppSetUpPinPageCubit.close();
        await testDatabase.close();
      });
    });
  });
}
