import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/a_local_pin_set_up_page_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/local_pin_set_up_page_cubit.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_confirm_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_enter_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_invalid_state.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../../utils/database_mock.dart';
import '../../../../../utils/test_database.dart';

Future<void> main() async {
  final TestDatabase testDatabase = TestDatabase();

  setUpAll(() async {
    await testDatabase.init(
      databaseMock: DatabaseMock.testSecretsMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );
  });

  group('Tests of a successful password setting process', () {
    late PasswordModel? actualPasswordModel;
    late LocalPinSetUpPageCubit actualLocalPinSetUpPageCubit;

    setUpAll(() {
      actualLocalPinSetUpPageCubit = LocalPinSetUpPageCubit(passwordValidCallback: (PasswordModel passwordModel) => actualPasswordModel = passwordModel);
    });

    test('Should [emit LocalPinSetUpPageEnterState] with [EMPTY firstPinNumbers] as initial state', () async {
      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageEnterState.empty();

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });

    test('Should [emit LocalPinSetUpPageEnterState] with [FILLED firstPinNumbers]', () async {
      // Act
      actualLocalPinSetUpPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageEnterState(firstPinNumbers: <int>[1, 1, 1, 1]);

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });

    test('Should [emit LocalPinSetUpPageConfirmState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
      // Act
      actualLocalPinSetUpPageCubit.setupFirstPin();

      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageConfirmState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[],
      );

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });

    test('Should [emit LocalPinSetUpPageConfirmState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
      // Act
      actualLocalPinSetUpPageCubit.updateConfirmPin(<int>[1, 1, 1, 1]);

      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageConfirmState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[1, 1, 1, 1],
      );

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });

    test('Should [return PasswordModel] if [passwords EQUAL]', () async {
      // Act
      await actualLocalPinSetUpPageCubit.setupConfirmPin();

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualPasswordModel, expectedPasswordModel);
    });
  });

  group('Tests of a password setting process with wrong confirm password provided', () {
    late LocalPinSetUpPageCubit actualLocalPinSetUpPageCubit;

    setUpAll(() {
      actualLocalPinSetUpPageCubit = LocalPinSetUpPageCubit(passwordValidCallback: (_) {});
    });

    test('Should [emit LocalPinSetUpPageEnterState] with [EMPTY firstPinNumbers] as initial state', () async {
      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageEnterState.empty();

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });

    test('Should [emit LocalPinSetUpPageEnterState] with [FILLED firstPinNumbers]', () async {
      // Act
      actualLocalPinSetUpPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageEnterState(firstPinNumbers: <int>[1, 1, 1, 1]);

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });

    test('Should [emit LocalPinSetUpPageConfirmState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
      // Act
      actualLocalPinSetUpPageCubit.setupFirstPin();

      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageConfirmState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[],
      );

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });

    test('Should [emit LocalPinSetUpPageConfirmState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
      // Act
      actualLocalPinSetUpPageCubit.updateConfirmPin(<int>[9, 9, 9, 9]);

      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageConfirmState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[9, 9, 9, 9],
      );

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });

    test('Should [emit LocalPinSetUpPageInvalidState] if [passwords NOT EQUAL]', () async {
      // Act
      await actualLocalPinSetUpPageCubit.setupConfirmPin();

      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageInvalidState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[9, 9, 9, 9],
      );

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });

    test('Should [emit LocalPinSetUpPageEnterState] with [EMPTY firstPinNumbers] after resetting', () async {
      // Act
      actualLocalPinSetUpPageCubit.resetAllPins();

      // Assert
      ALocalPinSetUpPageState expectedLocalPinSetUpPageState = const LocalPinSetUpPageEnterState.empty();

      expect(actualLocalPinSetUpPageCubit.state, expectedLocalPinSetUpPageState);
    });
  });

  tearDownAll(testDatabase.close);
}
