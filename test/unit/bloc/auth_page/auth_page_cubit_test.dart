import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/bloc/auth_page/auth_page_cubit.dart';
import 'package:snuggle/config/locator.dart';

void main() {
  initLocator();

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });
  group('Tests of AuthPageCubit States: ', () {
    AuthPageCubit authPageCubit = AuthPageCubit();
    test('Should return initial state of [AuthPageInitialState]', () {
      // Assert
      expect(authPageCubit.state, AuthPageInitialState());
    });

    blocTest<AuthPageCubit, AAuthPageState>(
      'Should return a [AuthPageLoadingAuthenticationState and AuthPageSuccessAuthenticationState ] after user sets up a pin and authenticates in [AuthPage]',

      // Arrange
      build: () => authPageCubit,

      // Act
      act: (AuthPageCubit authPageCubit) async {
        String pin = 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==';
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'is_authenticated': 'true',
          'encrypted_hash_mnemonic': pin,
        });
        await authPageCubit.verifyAuthentication(pin: '0000');
      },

      // Assert
      expect: () => <AAuthPageState>[AuthPageLoadingAuthenticationState(), AuthPageSuccessAuthenticationState()],
    );

    blocTest<AuthPageCubit, AAuthPageState>(
      'Should return a [AuthPageLoadingAuthenticationState and AuthPageInvalidAuthenticationState] after user wrongly authenticates in [AuthPage]',

      // Arrange
      build: AuthPageCubit.new,

      // Act
      act: (AuthPageCubit authPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'is_authenticated': 'true',
          'encrypted_hash_mnemonic': 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==',
        });
        await authPageCubit.verifyAuthentication(pin: '000');
      },

      // Assert
      expect: () => <AAuthPageState>[AuthPageLoadingAuthenticationState(), AuthPageInvalidAuthenticationState()],
    );
    blocTest<AuthPageCubit, AAuthPageState>(
      'Should return a [AuthPageLoadingAuthenticationState,AuthPageErrorState] as User attempts to verify a pin, when there is no authentication setup',

      // Arrange
      build: AuthPageCubit.new,

      // Act
      act: (AuthPageCubit authPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{'is_authenticated': 'false'});

        await authPageCubit.verifyAuthentication(pin: '0000');
      },

      // Assert
      expect: () => <AAuthPageState>[AuthPageLoadingAuthenticationState(), AuthPageErrorState()],
    );
  });
}
