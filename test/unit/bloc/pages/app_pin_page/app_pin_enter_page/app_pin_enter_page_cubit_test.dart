import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/a_app_pin_enter_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/app_pin_enter_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/states/app_pin_enter_page_invalid_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/states/app_pin_enter_page_state.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late AppPinEnterPageCubit actualPinEnterPageCubit;

  group('Tests of [AppPinEnterPageCubit]', () {
    group('Tests of [AppPinEnterPageCubit] when [PIN CORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualPinEnterPageCubit = AppPinEnterPageCubit();
      });

      tearDown(() async {
        await actualPinEnterPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppPinEnterPageState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        const AAppPinEnterPageState expectedAppPinEnterPageState = AppPinEnterPageState.empty();

        expect(actualPinEnterPageCubit.state, expectedAppPinEnterPageState);
      });

      test('Should [emit AppPinEnterPageState] with [FILLED pinNumbers]', () async {
        // Act
        actualPinEnterPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

        // Assert
        const AAppPinEnterPageState expectedAppPinEnterPageState = AppPinEnterPageState(
          pinNumbers: <int>[1, 1, 1, 1],
          invalidAttemptsCount: 0,
        );

        expect(actualPinEnterPageCubit.state, expectedAppPinEnterPageState);
      });

      test('Should keep state if [PIN CORRECT]', () async {
        // Arrange
        actualPinEnterPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

        // Act
        await actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter);

        // Assert
        const AAppPinEnterPageState expectedAppPinEnterPageState = AppPinEnterPageState(
          pinNumbers: <int>[1, 1, 1, 1],
          invalidAttemptsCount: 0,
        );

        expect(actualPinEnterPageCubit.state, expectedAppPinEnterPageState);
      });
    });

    group('Tests of [AppPinEnterPageCubit] when [PIN INCORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualPinEnterPageCubit = AppPinEnterPageCubit();
      });

      tearDown(() async {
        await actualPinEnterPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppPinEnterPageState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        const AAppPinEnterPageState expectedAppPinEnterPageState = AppPinEnterPageState.empty();

        expect(actualPinEnterPageCubit.state, expectedAppPinEnterPageState);
      });

      test('Should [emit AppPinEnterPageState] with [FILLED pinNumbers]', () async {
        // Act
        actualPinEnterPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Assert
        const AAppPinEnterPageState expectedAppPinEnterPageState = AppPinEnterPageState(
          pinNumbers: <int>[9, 9, 9, 9],
          invalidAttemptsCount: 0,
        );

        expect(actualPinEnterPageCubit.state, expectedAppPinEnterPageState);
      });

      test('Should [emit AppPinEnterPageInvalidState] and throw [InvalidPasswordException] if [PIN INCORRECT] (attempt #1)', () async {
        // Arrange
        actualPinEnterPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Act
        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        const AAppPinEnterPageState expectedAppPinEnterPageState = AppPinEnterPageInvalidState(
          pinNumbers: <int>[9, 9, 9, 9],
          invalidAttemptsCount: 1,
        );

        expect(actualPinEnterPageCubit.state, expectedAppPinEnterPageState);
        expect(actualPinEnterPageCubit.state.attemptsLeft, 2);
      });

      test('Should [increment invalidAttempts] on second invalid attempt (attempt #2)', () async {
        // Arrange
        actualPinEnterPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Act
        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );

        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        const AAppPinEnterPageState expectedAppPinEnterPageState = AppPinEnterPageInvalidState(
          pinNumbers: <int>[9, 9, 9, 9],
          invalidAttemptsCount: 2,
        );

        expect(actualPinEnterPageCubit.state, expectedAppPinEnterPageState);
        expect(actualPinEnterPageCubit.state.attemptsLeft, 1);
      });

      test('Should [keep invalidAttemptsCount] when calling updatePinNumbers after invalid attempt', () async {
        // Arrange
        actualPinEnterPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Act
        actualPinEnterPageCubit.updatePinNumbers(const <int>[1, 2, 3, 4]);

        // Assert
        const AAppPinEnterPageState expectedAppPinEnterPageState = AppPinEnterPageState(
          pinNumbers: <int>[1, 2, 3, 4],
          invalidAttemptsCount: 1,
        );

        expect(actualPinEnterPageCubit.state, expectedAppPinEnterPageState);
        expect(actualPinEnterPageCubit.state.attemptsLeft, 2);
      });

      test('Should [increase invalid attempts count to 1] after 1 invalid attempt', () async {
        // Arrange
        actualPinEnterPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        // Act
        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualPinEnterPageCubit.state.invalidAttemptsCount, 1);
        expect(actualPinEnterPageCubit.state.attemptsLeft, 2);
        expect(await storage.read(key: 'wipe_test_key'), '1');
      });

      test('Should [increase invalid attempts count to 2] after 2 invalid attempts', () async {
        // Arrange
        actualPinEnterPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Act
        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualPinEnterPageCubit.state.invalidAttemptsCount, 2);
        expect(actualPinEnterPageCubit.state.attemptsLeft, 1);
        expect(await storage.read(key: 'wipe_test_key'), '1');
      });

      test('Should [wipe secure storage] after 3 invalid attempts', () async {
        // Arrange
        actualPinEnterPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );
        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Act
        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.enter),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualPinEnterPageCubit.state.invalidAttemptsCount, 3);
        expect(actualPinEnterPageCubit.state.attemptsLeft, 0);
        expect(await storage.read(key: 'wipe_test_key'), null);
      });

      test('Should [not wipe secure storage] if [PIN INCORRECT] and [appPinType] is [changePin]', () async {
        // Arrange
        actualPinEnterPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        // Act
        await expectLater(
          () => actualPinEnterPageCubit.authenticate(appPinType: AppPinType.change),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualPinEnterPageCubit.state.invalidAttemptsCount, 0);
        expect(actualPinEnterPageCubit.state.attemptsLeft, 3);
        expect(await storage.read(key: 'wipe_test_key'), '1');
        expect(
          await storage.read(key: 'encryptedMasterKey'),
          '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
        );
      });
    });
  });
}
