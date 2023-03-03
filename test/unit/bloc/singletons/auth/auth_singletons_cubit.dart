import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/singletons/auth/auth_singleton_cubit.dart';

void main() {
  group('Tests of AuthSingletonCubit States:', () {
    const String hashedPassword = '409aeef82584ac10084c368e2c8bce5e00c9e5abb0c5e7e184ef7b784737866e';

    test('Should return initial state of AuthSingletonState', () {
      //  Arrange
      final AuthSingletonCubit actualAuthSingletonCubit = AuthSingletonCubit();

      //  Assert
      AuthSingletonState expectedAuthSingletonState = const AuthSingletonState(hashedAppPassword: null);
      expect(actualAuthSingletonCubit.state, equals(expectedAuthSingletonState));
    });

    blocTest<AuthSingletonCubit, AuthSingletonState>(
      'Should emit a new state with a [hashedPassword]',
      build: () {
        return AuthSingletonCubit();
      },

      // Act
      act: (AuthSingletonCubit actualAuthSingletonCubit) => actualAuthSingletonCubit.setPassword(hashedPassword),

      // Assert
      expect: () => <AuthSingletonState>[const AuthSingletonState(hashedAppPassword: hashedPassword)],
    );
  });
}
