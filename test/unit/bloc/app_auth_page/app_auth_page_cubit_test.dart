import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/app_auth_page/app_auth_page_cubit.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_error_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_initial_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_invalid_password_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_load_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_success_state.dart';
import 'package:snggle/config/app_config.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/auth_service.dart';
import 'package:snggle/shared/models/salt_model.dart';

void main() {
  initLocator();
  final AuthService actualAuthService = globalLocator<AuthService>();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of AppAuthPage States:', () {
    test('Should return initial state of [AppAuthPageInitialState]', () {
      AppAuthPageCubit actualAppAuthPageCubit = AppAuthPageCubit();
      // Assert
      expect(actualAppAuthPageCubit.state, AppAuthPageInitialState());
    });

    blocTest<AppAuthPageCubit, AAppAuthPageState>(
      'Should return state of [AppAuthPageLoadState] followed by [AppAuthPageErrorState], as no authentication is setup',
      // Arrange
      build: () {
        return AppAuthPageCubit();
      },

      // Act
      act: (AppAuthPageCubit actualAppAuthPageCubit) async {
        await actualAppAuthPageCubit.authenticate(password: AppConfig.defaultPassword);
      },

      // Assert
      expect: () => <AAppAuthPageState>[AppAuthPageLoadState(), AppAuthPageErrorState()],
    );

    blocTest<AppAuthPageCubit, AAppAuthPageState>(
      'Should return final state of [AppAuthPageSuccessState] as authentication is setup, password exist and is valid',
      // Arrange
      build: () {
        return AppAuthPageCubit();
      },

      // Act
      act: (AppAuthPageCubit actualAppAuthPageCubit) async {
        String actualHashedDefaultPassword = '34f9bb6c4bdc40f7c0287c9fdce812c8b4999e599599fa1fb78d5196024357c0';
        SaltModel actualSaltModel = await SaltModel.generateSalt(hashedPassword: actualHashedDefaultPassword, isDefaultPassword: true);
        await actualAuthService.setSaltModel(saltModel: actualSaltModel);
        await actualAppAuthPageCubit.authenticate(password: AppConfig.defaultPassword);
      },

      // Assert
      expect: () => <AAppAuthPageState>[AppAuthPageLoadState(), AppAuthPageSuccessState()],
    );

    blocTest<AppAuthPageCubit, AAppAuthPageState>(
      'Should return final state of [AppAuthPageInvalidPasswordState]  as authentication is setup, password exist and is invalid',
      // Arrange
      build: () {
        return AppAuthPageCubit();
      },

      // Act
      act: (AppAuthPageCubit actualAppAuthPageCubit) async {
        SaltModel actualSaltModel = await SaltModel.generateSalt(hashedPassword: AppConfig.defaultPassword, isDefaultPassword: true);
        await actualAuthService.setSaltModel(saltModel: actualSaltModel);
        await actualAppAuthPageCubit.authenticate(password: 'wrong_password');
      },

      // Assert
      expect: () => <AAppAuthPageState>[AppAuthPageLoadState(), AppAuthPageInvalidPasswordState()],
    );
  });
}
