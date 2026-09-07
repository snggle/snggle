import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/app_pin_set_up_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_confirm_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_enter_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_loading_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_pin_page_invalid_state.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late AppPinSetUpPageCubit actualAppPinSetUpPageCubit;

  group('Tests of [AppPinSetUpPageCubit]', () {
    group('Tests of [AppPinType.setUp] process when [confirm pin CORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.emptyDatabaseMock,
          appPasswordModel: PasswordModel.defaultPassword(),
        );

        actualAppPinSetUpPageCubit = AppPinSetUpPageCubit(appPinType: AppPinType.setUp);
      });

      tearDown(() async {
        await actualAppPinSetUpPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppPinSetUpPageEnterState] with [EMPTY firstPinNumbers] as initial state', () {
        // Arrange
        const AppPinSetUpPageEnterState expectedAppPinSetUpPageState = AppPinSetUpPageEnterState.empty();

        // Assert
        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });

      test('Should [emit AppPinSetUpPageEnterState] with [FILLED firstPinNumbers]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const AppPinSetUpPageEnterState expectedAppPinSetUpPageState = AppPinSetUpPageEnterState(firstPinNumbers: firstPinList);

        // Act
        actualAppPinSetUpPageCubit.updateFirstPin(firstPinList);

        // Assert
        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });

      test('Should [emit AppPinSetUpPageConfirmState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers] after [setUpFirstPin]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const AppPinSetUpPageConfirmState expectedAppPinSetUpPageState = AppPinSetUpPageConfirmState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: <int>[],
        );

        // Act
        actualAppPinSetUpPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin();

        // Assert
        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });

      test('Should [emit AppPinSetUpPageConfirmState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const List<int> confirmPinList = <int>[1, 1, 1, 1];
        const AppPinSetUpPageConfirmState expectedAppPinSetUpPageState = AppPinSetUpPageConfirmState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: confirmPinList,
        );

        // Act
        actualAppPinSetUpPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(confirmPinList);

        // Assert
        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });

      test('Should [emit AppPinSetUpPageLoadingState] immediately after starting [setUpConfirmPin] when [confirm pin MATCHES]', () async {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const List<int> confirmPinList = <int>[1, 1, 1, 1];

        actualAppPinSetUpPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(confirmPinList);

        // Act

        Future<void> safeFuture = actualAppPinSetUpPageCubit.setUpConfirmPin().catchError((_) {});
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(actualAppPinSetUpPageCubit.state, const AppPinSetUpPageLoadingState());

        await safeFuture;
      });
    });

    group('Tests of [AppPinType.setUp] process when [confirm pin INCORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.emptyDatabaseMock,
          appPasswordModel: PasswordModel.defaultPassword(),
        );

        actualAppPinSetUpPageCubit = AppPinSetUpPageCubit(appPinType: AppPinType.setUp);
      });

      tearDown(() async {
        await actualAppPinSetUpPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppPinSetUpPageEnterState] with [EMPTY firstPinNumbers] as initial state', () {
        // Arrange
        const AppPinSetUpPageEnterState expectedAppPinSetUpPageState = AppPinSetUpPageEnterState.empty();

        // Assert
        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });

      test('Should [emit AppPinSetUpPageEnterState] with [FILLED firstPinNumbers]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const AppPinSetUpPageEnterState expectedAppPinSetUpPageState = AppPinSetUpPageEnterState(firstPinNumbers: firstPinList);

        // Act
        actualAppPinSetUpPageCubit.updateFirstPin(firstPinList);

        // Assert
        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });

      test('Should [emit AppPinSetUpPageConfirmState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers] after [setUpFirstPin]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const AppPinSetUpPageConfirmState expectedAppPinSetUpPageState = AppPinSetUpPageConfirmState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: <int>[],
        );

        // Act
        actualAppPinSetUpPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin();

        // Assert
        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });

      test('Should [emit AppPinSetUpPageConfirmState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const List<int> wrongConfirmPin = <int>[9, 9, 9, 9];
        const AppPinSetUpPageConfirmState expectedAppPinSetUpPageState = AppPinSetUpPageConfirmState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: wrongConfirmPin,
        );

        // Act
        actualAppPinSetUpPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(wrongConfirmPin);

        // Assert
        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });

      test('Should [emit AppPinSetUpPageInvalidState] and throw [InvalidPasswordException] when [confirm pin MISMATCHES]', () async {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const List<int> wrongConfirmPin = <int>[9, 9, 9, 9];

        actualAppPinSetUpPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(wrongConfirmPin);

        const AppPinSetUpPageInvalidState expectedAppPinSetUpPageState = AppPinSetUpPageInvalidState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: wrongConfirmPin,
        );

        // Assert
        await expectLater(
          () => actualAppPinSetUpPageCubit.setUpConfirmPin(),
          throwsA(isA<InvalidPasswordException>()),
        );

        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });

      test('Should [emit AppPinSetUpPageEnterState] with [EMPTY firstPinNumbers] after [resetAllPins]', () {
        // Arrange
        const AppPinSetUpPageEnterState expectedAppPinSetUpPageState = AppPinSetUpPageEnterState.empty();

        // Act
        actualAppPinSetUpPageCubit.resetAllPins();

        // Assert
        expect(actualAppPinSetUpPageCubit.state, expectedAppPinSetUpPageState);
      });
    });

    group('Tests of [AppPinType.changePin] process when [confirm pin CORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualAppPinSetUpPageCubit = AppPinSetUpPageCubit(appPinType: AppPinType.change);
      });

      tearDown(() async {
        await actualAppPinSetUpPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppPinSetUpPageLoadingState] immediately after starting [setUpConfirmPin] when [confirm pin MATCHES]', () async {
        // Arrange
        const List<int> firstPinList = <int>[2, 2, 2, 2];
        const List<int> confirmPinList = <int>[2, 2, 2, 2];

        actualAppPinSetUpPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(confirmPinList);

        // Act
        Future<void> future = actualAppPinSetUpPageCubit.setUpConfirmPin();
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(actualAppPinSetUpPageCubit.state, const AppPinSetUpPageLoadingState());

        await future;
      });
    });
  });
}
