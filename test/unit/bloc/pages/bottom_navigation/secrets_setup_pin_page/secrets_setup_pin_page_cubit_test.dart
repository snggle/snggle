import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/secrets_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_invalid_pin_state.dart';
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
    late SecretsSetupPinPageCubit actualSecretsSetupPinPageCubit;

    setUpAll(() {
      actualSecretsSetupPinPageCubit = SecretsSetupPinPageCubit(passwordValidCallback: (PasswordModel passwordModel) => actualPasswordModel = passwordModel);
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState.empty();

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [FILLED firstPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState(firstPinNumbers: <int>[1, 1, 1, 1]);

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.setupFirstPin();

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.updateConfirmPin(<int>[1, 1, 1, 1]);

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[1, 1, 1, 1],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [return PasswordModel] if [passwords EQUAL]', () async {
      // Act
      await actualSecretsSetupPinPageCubit.setupConfirmPin();

      // Assert
      PasswordModel expectedPasswordModel = PasswordModel.fromPlaintext('1111');

      expect(actualPasswordModel, expectedPasswordModel);
    });
  });

  group('Tests of a password setting process with wrong confirm password provided', () {
    late SecretsSetupPinPageCubit actualSecretsSetupPinPageCubit;

    setUpAll(() {
      actualSecretsSetupPinPageCubit = SecretsSetupPinPageCubit(passwordValidCallback: (_) {});
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] as initial state', () async {
      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState.empty();

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [FILLED firstPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.updateFirstPin(const <int>[1, 1, 1, 1]);

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState(firstPinNumbers: <int>[1, 1, 1, 1]);

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [EMPTY confirmPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.setupFirstPin();

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageConfirmPinState] with [FILLED firstPinNumbers] and [FILLED confirmPinNumbers]', () async {
      // Act
      actualSecretsSetupPinPageCubit.updateConfirmPin(<int>[9, 9, 9, 9]);

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageConfirmPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[9, 9, 9, 9],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageInvalidPinState] if [passwords NOT EQUAL]', () async {
      // Act
      await actualSecretsSetupPinPageCubit.setupConfirmPin();

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageInvalidPinState(
        firstPinNumbers: <int>[1, 1, 1, 1],
        confirmPinNumbers: <int>[9, 9, 9, 9],
      );

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });

    test('Should [emit SecretsSetupPinPageEnterPinState] with [EMPTY firstPinNumbers] after resetting', () async {
      // Act
      actualSecretsSetupPinPageCubit.resetAllPins();

      // Assert
      ASecretsSetupPinPageState expectedSecretsSetupPinPageState = const SecretsSetupPinPageEnterPinState.empty();

      expect(actualSecretsSetupPinPageCubit.state, expectedSecretsSetupPinPageState);
    });
  });

  tearDownAll(testDatabase.close);
}
