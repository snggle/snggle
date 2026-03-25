import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/a_app_enter_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/app_enter_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/states/app_enter_invalid_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/states/app_enter_pin_page_state.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late AppEnterPinPageCubit actualEnterPinPageCubit;

  group('Tests of [AppEnterPinPageCubit]', () {
    group('Tests of [AppEnterPinPageCubit] when [PIN CORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualEnterPinPageCubit = AppEnterPinPageCubit();
      });

      tearDown(() async {
        await actualEnterPinPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppEnterPinPageState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        const AAppEnterPinPageState expectedAppEnterPinPageState = AppEnterPinPageState.empty();

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });

      test('Should [emit AppEnterPinPageState] with [FILLED pinNumbers]', () async {
        // Act
        actualEnterPinPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

        // Assert
        const AAppEnterPinPageState expectedAppEnterPinPageState = AppEnterPinPageState(
          pinNumbers: <int>[1, 1, 1, 1],
          invalidAttemptsCount: 0,
        );

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });

      test('Should keep state if [PIN CORRECT]', () async {
        // Arrange
        actualEnterPinPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

        // Act
        await actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin);

        // Assert
        const AAppEnterPinPageState expectedAppEnterPinPageState = AppEnterPinPageState(
          pinNumbers: <int>[1, 1, 1, 1],
          invalidAttemptsCount: 0,
        );

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });
    });

    group('Tests of [AppEnterPinPageCubit] when [PIN INCORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualEnterPinPageCubit = AppEnterPinPageCubit();
      });

      tearDown(() async {
        await actualEnterPinPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppEnterPinPageState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        const AAppEnterPinPageState expectedAppEnterPinPageState = AppEnterPinPageState.empty();

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });

      test('Should [emit AppEnterPinPageState] with [FILLED pinNumbers]', () async {
        // Act
        actualEnterPinPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Assert
        const AAppEnterPinPageState expectedAppEnterPinPageState = AppEnterPinPageState(
          pinNumbers: <int>[9, 9, 9, 9],
          invalidAttemptsCount: 0,
        );

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
      });

      test('Should [emit AppEnterInvalidPinPageState] and throw [InvalidPasswordException] if [PIN INCORRECT] (attempt #1)', () async {
        // Arrange
        actualEnterPinPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Act
        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        const AAppEnterPinPageState expectedAppEnterPinPageState = AppEnterInvalidPinPageState(
          pinNumbers: <int>[9, 9, 9, 9],
          invalidAttemptsCount: 1,
        );

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
        expect(actualEnterPinPageCubit.state.attemptsLeft, 2);
      });

      test('Should [increment invalidAttempts] on second invalid attempt (attempt #2)', () async {
        // Arrange
        actualEnterPinPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Act
        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );

        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        const AAppEnterPinPageState expectedAppEnterPinPageState = AppEnterInvalidPinPageState(
          pinNumbers: <int>[9, 9, 9, 9],
          invalidAttemptsCount: 2,
        );

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
        expect(actualEnterPinPageCubit.state.attemptsLeft, 1);
      });

      test('Should [keep invalidAttemptsCount] when calling updatePinNumbers after invalid attempt', () async {
        // Arrange
        actualEnterPinPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Act
        actualEnterPinPageCubit.updatePinNumbers(const <int>[1, 2, 3, 4]);

        // Assert
        const AAppEnterPinPageState expectedAppEnterPinPageState = AppEnterPinPageState(
          pinNumbers: <int>[1, 2, 3, 4],
          invalidAttemptsCount: 1,
        );

        expect(actualEnterPinPageCubit.state, expectedAppEnterPinPageState);
        expect(actualEnterPinPageCubit.state.attemptsLeft, 2);
      });

      test('Should [increase invalid attempts count to 1] after 1 invalid attempt', () async {
        // Arrange
        actualEnterPinPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        // Act
        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualEnterPinPageCubit.state.invalidAttemptsCount, 1);
        expect(actualEnterPinPageCubit.state.attemptsLeft, 2);
        expect(await storage.read(key: 'wipe_test_key'), '1');
      });

      test('Should [increase invalid attempts count to 2] after 2 invalid attempts', () async {
        // Arrange
        actualEnterPinPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Act
        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualEnterPinPageCubit.state.invalidAttemptsCount, 2);
        expect(actualEnterPinPageCubit.state.attemptsLeft, 1);
        expect(await storage.read(key: 'wipe_test_key'), '1');
      });

      test('Should [wipe secure storage] after 3 invalid attempts', () async {
        // Arrange
        actualEnterPinPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );
        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Act
        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.enterPin),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualEnterPinPageCubit.state.invalidAttemptsCount, 3);
        expect(actualEnterPinPageCubit.state.attemptsLeft, 0);
        expect(await storage.read(key: 'wipe_test_key'), null);
      });

      test('Should [not wipe secure storage] if [PIN INCORRECT] and [appPinType] is [changePin]', () async {
        // Arrange
        actualEnterPinPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'encryptedMasterKey':
              '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
          'wipe_test_key': '1',
        });

        const FlutterSecureStorage storage = FlutterSecureStorage();
        expect(await storage.read(key: 'wipe_test_key'), '1');

        // Act
        await expectLater(
          () => actualEnterPinPageCubit.authenticate(appPinType: AppPinType.changePin),
          throwsA(isA<InvalidPasswordException>()),
        );

        // Assert
        expect(actualEnterPinPageCubit.state.invalidAttemptsCount, 0);
        expect(actualEnterPinPageCubit.state.attemptsLeft, 3);
        expect(await storage.read(key: 'wipe_test_key'), '1');
        expect(
          await storage.read(key: 'encryptedMasterKey'),
          '2BoJ22t9EvJtpluc/3P/gP6duxeyZrWhhNUI2BdyGaK+u5tsguh3y3cHvptFIsarrUcYYLFs+Yesgs4rW/b/S0GpcUxm9akkSWurQ/WB3bfZrPFHnYWJ2xSrAGJ7YtYv7Lm7zA==',
        );
      });
    });
  });
}
