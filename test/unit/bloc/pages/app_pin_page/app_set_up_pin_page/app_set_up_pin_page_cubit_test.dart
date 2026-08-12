import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/app_set_up_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_loading_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_success_state.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

void main() {
  late TestDatabase testDatabase;
  late AppSetUpPinPageCubit actualAppSetUpPinPageCubit;

  group('Tests of [AppSetUpPinPageCubit]', () {
    group('Tests of [AppPinType.setUpPin] process when [confirm pin CORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.emptyDatabaseMock,
          appPasswordModel: PasswordModel.defaultPassword(),
        );

        String mnemonicString = 'brave pair belt judge visual tunnel dinner siren dentist craft effort decrease';

        MnemonicModel mnemonicModel = MnemonicModel.fromString(mnemonicString);

        actualAppSetUpPinPageCubit = AppSetUpPinPageCubit(
          appPinType: AppPinType.setUpPin,
          mnemonicModel: mnemonicModel,
        );
      });

      tearDown(() async {
        await actualAppSetUpPinPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () {
        // Arrange
        const AppSetUpPinPageEnterPinState expectedState = AppSetUpPinPageEnterPinState.empty();

        // Assert
        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [FILLED firstPinNumbers]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const AppSetUpPinPageEnterPinState expectedState = AppSetUpPinPageEnterPinState(firstPinNumbers: firstPinList);

        // Act
        actualAppSetUpPinPageCubit.updateFirstPin(firstPinList);

        // Assert
        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });

      test('Should [emit AppSetUpPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers] after [setUpFirstPin]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const AppSetUpPinPageConfirmPinState expectedState = AppSetUpPinPageConfirmPinState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: <int>[],
        );

        // Act
        actualAppSetUpPinPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin();

        // Assert
        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });

      test('Should [emit AppSetUpPinPageConfirmPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const List<int> confirmPinList = <int>[1, 1, 1, 1];
        const AppSetUpPinPageConfirmPinState expectedState = AppSetUpPinPageConfirmPinState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: confirmPinList,
        );

        // Act
        actualAppSetUpPinPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(confirmPinList);

        // Assert
        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });

      test('Should [emit AppSetUpPinPageLoadingState] immediately after starting [setUpConfirmPin] when [confirm pin MATCHES]', () async {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const List<int> confirmPinList = <int>[1, 1, 1, 1];

        actualAppSetUpPinPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(confirmPinList);

        // Act

        Future<void> safeFuture = actualAppSetUpPinPageCubit.setUpConfirmPin().catchError((_) {});
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(actualAppSetUpPinPageCubit.state, const AppSetUpPinPageLoadingState());

        await safeFuture;
      });

      test(
        'Should [emit AppSetUpPinPageLoadingState] and then [AppSetUpPinPageSuccessState] when [confirm pin MATCHES]',
        () async {
          // Arrange
          const List<int> firstPinList = <int>[2, 2, 2, 2];
          const List<int> confirmPinList = <int>[2, 2, 2, 2];

          actualAppSetUpPinPageCubit
            ..updateFirstPin(firstPinList)
            ..setUpFirstPin()
            ..updateConfirmPin(confirmPinList);

          // Act
          Future<void> future = actualAppSetUpPinPageCubit.setUpConfirmPin();
          await Future<void>.delayed(Duration.zero);

          // Assert
          expect(
            actualAppSetUpPinPageCubit.state,
            const AppSetUpPinPageLoadingState(),
          );

          await future;

          expect(
            actualAppSetUpPinPageCubit.state,
            const AppSetUpPinPageSuccessState(),
          );
        },
      );
    });

    group('Tests of [AppPinType.setUpPin] process when [confirm pin INCORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.emptyDatabaseMock,
          appPasswordModel: PasswordModel.defaultPassword(),
        );

        actualAppSetUpPinPageCubit = AppSetUpPinPageCubit(appPinType: AppPinType.setUpPin);
      });

      tearDown(() async {
        await actualAppSetUpPinPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () {
        // Arrange
        const AppSetUpPinPageEnterPinState expectedState = AppSetUpPinPageEnterPinState.empty();

        // Assert
        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [FILLED firstPinNumbers]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const AppSetUpPinPageEnterPinState expectedState = AppSetUpPinPageEnterPinState(firstPinNumbers: firstPinList);

        // Act
        actualAppSetUpPinPageCubit.updateFirstPin(firstPinList);

        // Assert
        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });

      test('Should [emit AppSetUpPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers] after [setUpFirstPin]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const AppSetUpPinPageConfirmPinState expectedState = AppSetUpPinPageConfirmPinState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: <int>[],
        );

        // Act
        actualAppSetUpPinPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin();

        // Assert
        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });

      test('Should [emit AppSetUpPinPageConfirmPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const List<int> wrongConfirmPin = <int>[9, 9, 9, 9];
        const AppSetUpPinPageConfirmPinState expectedState = AppSetUpPinPageConfirmPinState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: wrongConfirmPin,
        );

        // Act
        actualAppSetUpPinPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(wrongConfirmPin);

        // Assert
        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });

      test('Should [emit AppSetUpPinPageInvalidPinState] and throw [InvalidPasswordException] when [confirm pin MISMATCHES]', () async {
        // Arrange
        const List<int> firstPinList = <int>[1, 1, 1, 1];
        const List<int> wrongConfirmPin = <int>[9, 9, 9, 9];

        actualAppSetUpPinPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(wrongConfirmPin);

        const AppSetUpPinPageInvalidPinState expectedState = AppSetUpPinPageInvalidPinState(
          firstPinNumbers: firstPinList,
          confirmPinNumbers: wrongConfirmPin,
        );

        // Assert
        await expectLater(
          () => actualAppSetUpPinPageCubit.setUpConfirmPin(),
          throwsA(isA<InvalidPasswordException>()),
        );

        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });

      test('Should [emit AppSetUpPinPageEnterPinState] with [EMPTY firstPinNumbers] after [resetAllPins]', () {
        // Arrange
        const AppSetUpPinPageEnterPinState expectedState = AppSetUpPinPageEnterPinState.empty();

        // Act
        actualAppSetUpPinPageCubit.resetAllPins();

        // Assert
        expect(actualAppSetUpPinPageCubit.state, expectedState);
      });
    });

    group('Tests of [AppPinType.changePin] process when [confirm pin CORRECT]', () {
      setUp(() async {
        testDatabase = TestDatabase();
        await testDatabase.init(
          databaseMock: DatabaseMock.masterKeyOnlyDatabaseMock,
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
        );

        actualAppSetUpPinPageCubit = AppSetUpPinPageCubit(appPinType: AppPinType.changePin);
      });

      tearDown(() async {
        await actualAppSetUpPinPageCubit.close();
        await Future<void>.sync(testDatabase.close);
      });

      test('Should [emit AppSetUpPinPageLoadingState] immediately after starting [setUpConfirmPin] when [confirm pin MATCHES]', () async {
        // Arrange
        const List<int> firstPinList = <int>[2, 2, 2, 2];
        const List<int> confirmPinList = <int>[2, 2, 2, 2];

        actualAppSetUpPinPageCubit
          ..updateFirstPin(firstPinList)
          ..setUpFirstPin()
          ..updateConfirmPin(confirmPinList);

        // Act
        Future<void> future = actualAppSetUpPinPageCubit.setUpConfirmPin();
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(actualAppSetUpPinPageCubit.state, const AppSetUpPinPageLoadingState());

        await future;
      });
    });
  });
}
