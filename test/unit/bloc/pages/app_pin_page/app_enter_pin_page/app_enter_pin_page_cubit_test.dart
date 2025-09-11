import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/a_app_enter_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/app_enter_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/states/app_enter_invalid_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/states/app_enter_pin_page_state.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

Future<void> main() async {
  final TestDatabase testDatabase = TestDatabase();
  late AppEnterPinPageCubit actualEnterPinPageCubit;

  group('Tests of [AppEnterPinPageCubit]', () {
    group('Tests of [AppEnterPinPageCubit] when [PIN CORRECT]', () {
      setUpAll(() async {
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualEnterPinPageCubit = AppEnterPinPageCubit();
      });

      test('Should [emit AppEnterPinPageState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        AAppEnterPinPageState expectedAppEnterPinPageState = const AppEnterPinPageState.empty();

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });

      test('Should [emit AppEnterPinPageState] with [FILLED pinNumbers]', () async {
        // Act
        actualEnterPinPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

        // Assert
        AAppEnterPinPageState expectedAppEnterPinPageState = const AppEnterPinPageState(pinNumbers: <int>[1, 1, 1, 1]);

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });

      test('Should [emit AppEnterPinPageState] with entered numbers if [PIN CORRECT]', () async {
        // Act
        await actualEnterPinPageCubit.authenticate();

        // Assert
        AAppEnterPinPageState expectedAppEnterPinPageState = const AppEnterPinPageState(pinNumbers: <int>[1, 1, 1, 1]);

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });

      tearDownAll(testDatabase.close);
    });

    group('Tests of [AppEnterPinPageCubit] when [PIN INCORRECT]', () {
      setUpAll(() async {
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualEnterPinPageCubit = AppEnterPinPageCubit();
      });

      test('Should [emit AppEnterPinPageState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        AAppEnterPinPageState expectedAppEnterPinPageState = const AppEnterPinPageState.empty();

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });

      test('Should [emit AppEnterPinPageState] with [FILLED pinNumbers]', () async {
        // Act
        actualEnterPinPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Assert
        AAppEnterPinPageState expectedAppEnterPinPageState = const AppEnterPinPageState(pinNumbers: <int>[9, 9, 9, 9]);

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });

      test('Should [emit AppEnterPageInvalidPinState] and throw [InvalidPasswordException] if [PIN INCORRECT]', () async {
        try {
          // Act
          await actualEnterPinPageCubit.authenticate();
        } catch (actualException) {
          // Assert
          AAppEnterPinPageState expectedAppEnterPinPageState = const AppEnterInvalidPinPageState(pinNumbers: <int>[9, 9, 9, 9]);

          expect(actualException, isA<InvalidPasswordException>());
          expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
        }
      });

      tearDownAll(testDatabase.close);
    });
  });
}
