import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/app_auth_page/a_app_auth_page_state.dart';
import 'package:snggle/bloc/pages/app_auth_page/app_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/app_auth_page/states/app_auth_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_auth_page/states/app_auth_page_invalid_pin_state.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';
import 'package:snggle/shared/models/password_model.dart';

Future<void> main() async {
  initLocator();

  late AppAuthPageCubit actualAppAuthPageCubit;
  late AuthSingletonCubit authSingletonCubit;

  // @formatter:off
  Map<String, String> filledMasterKeyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  group('Tests of [AppAuthPageCubit]', () {
    group('Tests of [AppAuthPageCubit] when [pin CORRECT]', () {
      setUpAll(() {
        authSingletonCubit = AuthSingletonCubit();
        actualAppAuthPageCubit = AppAuthPageCubit(authSingletonCubit: authSingletonCubit);
        FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));
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

      test('Should [setup pinNumbers] as an app password in [AuthSingletonCubit]', () async {
        // Act
        await actualAppAuthPageCubit.authenticate();
        PasswordModel? actualAppPasswordModel = authSingletonCubit.currentAppPasswordModel;

        // Assert
        PasswordModel? expectedAppPasswordModel = PasswordModel.fromPlaintext('1111');
        AAppAuthPageState expectedAppAuthPageState = const AppAuthPageEnterPinState(pinNumbers: <int>[1, 1, 1, 1]);

        expect(actualAppPasswordModel, expectedAppPasswordModel);
        expect(actualAppAuthPageCubit.state, expectedAppAuthPageState);
      });
    });

    group('Tests of [AppAuthPageCubit] when [pin INCORRECT]', () {
      setUpAll(() {
        authSingletonCubit = AuthSingletonCubit();
        actualAppAuthPageCubit = AppAuthPageCubit(authSingletonCubit: authSingletonCubit);
        FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));
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

      test('Should [emit AppAuthPageInvalidPinState] and throw [InvalidPasswordException]', () async {
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
    });
  });
}
