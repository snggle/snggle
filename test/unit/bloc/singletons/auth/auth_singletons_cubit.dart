import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';
import 'package:snggle/shared/models/password_model.dart';

void main() {
  group('Tests of AuthSingletonCubit States:', () {
    PasswordModel appPasswordModel = PasswordModel.fromPlaintext('password');

    test('Should return initial state of AuthSingletonState', () {
      //  Arrange
      final AuthSingletonCubit actualAuthSingletonCubit = AuthSingletonCubit();

      //  Assert
      AuthSingletonState expectedAuthSingletonState = const AuthSingletonState(appPasswordModel: null);
      expect(actualAuthSingletonCubit.state, equals(expectedAuthSingletonState));
    });

    blocTest<AuthSingletonCubit, AuthSingletonState>(
      'Should emit a new state with a [hashedPassword]',
      build: () {
        return AuthSingletonCubit();
      },

      // Act
      act: (AuthSingletonCubit actualAuthSingletonCubit) => actualAuthSingletonCubit.setAppPassword(appPasswordModel),

      // Assert
      expect: () => <AuthSingletonState>[AuthSingletonState(appPasswordModel: appPasswordModel)],
    );
  });
}
