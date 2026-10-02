import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/a_app_pin_auth_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/app_pin_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/states/app_pin_auth_page_enter_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/states/app_pin_auth_page_invalid_state.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late AppPinAuthPageCubit actualPinAuthPageCubit;

  group('Tests of [AppPinAuthPageCubit]', () {
    group('Tests of [AppPinAuthPageCubit] when [PIN CORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualPinAuthPageCubit = AppPinAuthPageCubit();
      });

      tearDown(() async {
        await actualPinAuthPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppPinAuthPageState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        const AAppPinAuthPageState expectedAppPinAuthPageState = AppPinAuthPageEnterState.empty();

        expect(actualPinAuthPageCubit.state, expectedAppPinAuthPageState);
      });

      test('Should [emit AppPinAuthPageState] with [FILLED pinNumbers]', () async {
        // Act
        actualPinAuthPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

        // Assert
        const AAppPinAuthPageState expectedAppPinAuthPageState = AppPinAuthPageEnterState(
          pinNumbers: <int>[1, 1, 1, 1],
          invalidAttemptsCount: 0,
        );

        expect(actualPinAuthPageCubit.state, expectedAppPinAuthPageState);
      });

      test('Should keep state if [PIN CORRECT]', () async {
        // Arrange
        actualPinAuthPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

        // Act
        await actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth);

        // Assert
        const AAppPinAuthPageState expectedAppPinAuthPageState = AppPinAuthPageEnterState(
          pinNumbers: <int>[1, 1, 1, 1],
          invalidAttemptsCount: 0,
        );

        expect(actualPinAuthPageCubit.state, expectedAppPinAuthPageState);
      });
    });

    group('Tests of [AppPinAuthPageCubit] when [PIN INCORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualPinAuthPageCubit = AppPinAuthPageCubit();
      });

      tearDown(() async {
        await actualPinAuthPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppPinAuthPageState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        const AAppPinAuthPageState expectedAppPinAuthPageState = AppPinAuthPageEnterState.empty();

        expect(actualPinAuthPageCubit.state, expectedAppPinAuthPageState);
      });

      test('Should [emit AppPinAuthPageState] with [FILLED pinNumbers]', () async {
        // Act
        actualPinAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Assert
        const AAppPinAuthPageState expectedAppPinAuthPageState = AppPinAuthPageEnterState(
          pinNumbers: <int>[9, 9, 9, 9],
          invalidAttemptsCount: 0,
        );

        expect(actualPinAuthPageCubit.state, expectedAppPinAuthPageState);
      });

      test('Should [emit AppPinAuthPageInvalidState] and throw [InvalidPasswordException] if [PIN INCORRECT] (attempt #1)', () async {
        // Arrange
        actualPinAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Act
        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        const AAppPinAuthPageState expectedAppPinAuthPageState = AppPinAuthPageInvalidState(
          pinNumbers: <int>[9, 9, 9, 9],
          invalidAttemptsCount: 1,
        );

        expect(actualPinAuthPageCubit.state, expectedAppPinAuthPageState);
        expect(actualPinAuthPageCubit.state.attemptsLeft, 2);
      });

      test('Should [increment invalidAttempts] on second invalid attempt (attempt #2)', () async {
        // Arrange
        actualPinAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Act
        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );

        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        const AAppPinAuthPageState expectedAppPinAuthPageState = AppPinAuthPageInvalidState(
          pinNumbers: <int>[9, 9, 9, 9],
          invalidAttemptsCount: 2,
        );

        expect(actualPinAuthPageCubit.state, expectedAppPinAuthPageState);
        expect(actualPinAuthPageCubit.state.attemptsLeft, 1);
      });

      test('Should [keep invalidAttemptsCount] when calling updatePinNumbers after invalid attempt', () async {
        // Arrange
        actualPinAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Act
        actualPinAuthPageCubit.updatePinNumbers(const <int>[1, 2, 3, 4]);

        // Assert
        const AAppPinAuthPageState expectedAppPinAuthPageState = AppPinAuthPageEnterState(
          pinNumbers: <int>[1, 2, 3, 4],
          invalidAttemptsCount: 1,
        );

        expect(actualPinAuthPageCubit.state, expectedAppPinAuthPageState);
        expect(actualPinAuthPageCubit.state.attemptsLeft, 2);
      });

      test('Should [increase invalid attempts count to 1] after 1 invalid attempt', () async {
        // Arrange
        actualPinAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        // Act
        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualPinAuthPageCubit.state.invalidAttemptsCount, 1);
        expect(actualPinAuthPageCubit.state.attemptsLeft, 2);
        expect(await storage.read(key: 'wipe_test_key'), '1');
      });

      test('Should [increase invalid attempts count to 2] after 2 invalid attempts', () async {
        // Arrange
        actualPinAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Act
        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualPinAuthPageCubit.state.invalidAttemptsCount, 2);
        expect(actualPinAuthPageCubit.state.attemptsLeft, 1);
        expect(await storage.read(key: 'wipe_test_key'), '1');
      });

      test('Should [wipe secure storage] after 3 invalid attempts', () async {
        // Arrange
        actualPinAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );
        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Act
        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.auth),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualPinAuthPageCubit.state.invalidAttemptsCount, 3);
        expect(actualPinAuthPageCubit.state.attemptsLeft, 0);
        expect(await storage.read(key: 'wipe_test_key'), null);
      });

      test('Should [not wipe secure storage] if [PIN INCORRECT] and [appPinType] is [changePin]', () async {
        // Arrange
        actualPinAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        // Act
        await expectLater(
          () => actualPinAuthPageCubit.authenticate(appPinType: AppPinType.change),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualPinAuthPageCubit.state.invalidAttemptsCount, 0);
        expect(actualPinAuthPageCubit.state.attemptsLeft, 3);
        expect(await storage.read(key: 'wipe_test_key'), '1');
        expect(
          await storage.read(key: 'encryptedMasterKey'),
          '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
        );
      });
    });
  });
}
