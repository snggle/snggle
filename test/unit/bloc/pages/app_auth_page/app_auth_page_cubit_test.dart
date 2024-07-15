import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_auth_page/a_app_auth_page_state.dart';
import 'package:snggle/bloc/pages/app_auth_page/app_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/app_auth_page/states/app_auth_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_auth_page/states/app_auth_page_invalid_pin_state.dart';
import 'package:snggle/infra/managers/secure_storage/secure_storage_key.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';

import '../../../../utils/test_database.dart';

Future<void> main() async {
  late TestDatabase testDatabase;
  late AppAuthPageCubit actualAppAuthPageCubit;

  group('Tests of [AppAuthPageCubit]', () {
    group('Tests of [AppAuthPageCubit] when [pin CORRECT]', () {
      setUpAll(() {
        // @formatter:off
        testDatabase = TestDatabase(
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
          secureStorageContent: <String, String>{
            SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
          },
        );

        actualAppAuthPageCubit = AppAuthPageCubit();
        // @formatter:on
      });

      test('Should [emit AppAuthPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        AAppAuthPageState expectedAppAuthPageState = const AppAuthPageEnterPinState.empty();

        expect(actualAppAuthPageCubit.state, expectedAppAuthPageState);
      });

      test('Should [emit AppAuthPageEnterPinState] with [FILLED pinNumbers]', () async {
        // Act
        actualAppAuthPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

        // Assert
        AAppAuthPageState expectedAppAuthPageState = const AppAuthPageEnterPinState(pinNumbers: <int>[1, 1, 1, 1]);

        expect(actualAppAuthPageCubit.state, expectedAppAuthPageState);
      });

      test('Should [emit AppAuthPageEnterPinState] with entered numbers if [pin CORRECT]', () async {
        // Act
        await actualAppAuthPageCubit.authenticate();

        // Assert
        AAppAuthPageState expectedAppAuthPageState = const AppAuthPageEnterPinState(pinNumbers: <int>[1, 1, 1, 1]);

        expect(actualAppAuthPageCubit.state, expectedAppAuthPageState);
      });

      tearDownAll(() {
        testDatabase.close();
      });
    });

    group('Tests of [AppAuthPageCubit] when [pin INCORRECT]', () {
      setUpAll(() {
        // @formatter:off
        testDatabase = TestDatabase(
          appPasswordModel: PasswordModel.fromPlaintext('1111'),
          secureStorageContent: <String, String>{
            SecureStorageKey.encryptedMasterKey.name:'49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
          },
        );

        actualAppAuthPageCubit = AppAuthPageCubit();
        // @formatter:on
      });

      test('Should [emit AppAuthPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        AAppAuthPageState expectedAppAuthPageState = const AppAuthPageEnterPinState.empty();

        expect(actualAppAuthPageCubit.state, expectedAppAuthPageState);
      });

      test('Should [emit AppAuthPageEnterPinState] with [FILLED pinNumbers]', () async {
        // Act
        actualAppAuthPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Assert
        AAppAuthPageState expectedAppAuthPageState = const AppAuthPageEnterPinState(pinNumbers: <int>[9, 9, 9, 9]);

        expect(actualAppAuthPageCubit.state, expectedAppAuthPageState);
      });

      test('Should [emit AppAuthPageInvalidPinState] and throw [InvalidPasswordException] if [pin INCORRECT]', () async {
        try {
          // Act
          await actualAppAuthPageCubit.authenticate();
        } catch (actualException) {
          // Assert
          AAppAuthPageState expectedAppAuthPageState = const AppAuthPageInvalidPinState(pinNumbers: <int>[9, 9, 9, 9]);

          expect(actualException, isA<InvalidPasswordException>());
          expect(actualAppAuthPageCubit.state, expectedAppAuthPageState);
        }
      });

      tearDownAll(() {
        testDatabase.close();
      });
    });
  });
}
