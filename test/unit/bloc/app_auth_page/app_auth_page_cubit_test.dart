import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/app_auth_page/app_auth_page_cubit.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_error_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_initial_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_invalid_password_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_load_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_success_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/master_key_service.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/value_objects/master_key_vo.dart';

void main() {
  initLocator();
  final MasterKeyService actuaMasterKeyService = globalLocator<MasterKeyService>();

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
        await actualAppAuthPageCubit.authenticate(passwordModel: PasswordModel.defaultPassword());
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
        PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');
        MnemonicModel actualMnemonicModel = MnemonicModel.fromString('tent gentle scout powder priority rotate lion boss urge chest legal win');
        MasterKeyVO actualMasterKeyVO = await MasterKeyVO.create(passwordModel: actualPasswordModel, mnemonicModel: actualMnemonicModel);

        await actuaMasterKeyService.setMasterKey(actualMasterKeyVO);
        await actualAppAuthPageCubit.authenticate(passwordModel: actualPasswordModel);
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
        PasswordModel actualPasswordModel = PasswordModel.fromPlaintext('password');
        MnemonicModel actualMnemonicModel = MnemonicModel.fromString('tent gentle scout powder priority rotate lion boss urge chest legal win');
        MasterKeyVO actualMasterKeyVO = await MasterKeyVO.create(passwordModel: actualPasswordModel, mnemonicModel: actualMnemonicModel);

        await actuaMasterKeyService.setMasterKey(actualMasterKeyVO);
        await actualAppAuthPageCubit.authenticate(passwordModel: PasswordModel.fromPlaintext('wrong_password'));
      },

      // Assert
      expect: () => <AAppAuthPageState>[AppAuthPageLoadState(), AppAuthPageInvalidPasswordState()],
    );
  });
}
