import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/bloc/authenticate_page/authenticate_page_cubit.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_error_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_initial_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_invalid_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_load_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_success_state.dart';
import 'package:snuggle/config/locator.dart';

void main() {
  initLocator();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });
  group('Tests of AuthenticatePageCubit States: ', () {
    AuthenticatePageCubit authenticatePageCubit = AuthenticatePageCubit();
    test('Should return initial state of [AuthenticatePageInitialState]', () {
      // Assert
      expect(authenticatePageCubit.state, AuthenticatePageInitialState());
    });

    blocTest<AuthenticatePageCubit, AAuthenticatePageState>(
      'Should return a [AuthenticatePageLoadState and AuthenticatePageSuccessState] after user sets up a pin and authenticates in [AuthenticatePage]',

      // Arrange
      build: () => authenticatePageCubit,

      // Act
      act: (AuthenticatePageCubit authenticatePageCubit) async {
        String pin = 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==';
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'is_authenticated': 'true',
          'hash_mnemonic': pin,
        });
        await authenticatePageCubit.verifyAuthentication(pin: '0000');
      },

      // Assert
      expect: () => <AAuthenticatePageState>[AuthenticatePageLoadState(), AuthenticatePageSuccessState()],
    );

    blocTest<AuthenticatePageCubit, AAuthenticatePageState>(
      'Should return a [AuthenticatePageLoadState and AuthenticatePageInvalidState] after user wrongly authenticates in [AuthenticatePage]',

      // Arrange
      build: AuthenticatePageCubit.new,

      // Act
      act: (AuthenticatePageCubit authenticatePageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'is_authenticated': 'true',
          'hash_mnemonic': 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==',
        });
        await authenticatePageCubit.verifyAuthentication(pin: '0001');
      },

      // Assert
      expect: () => <AAuthenticatePageState>[AuthenticatePageLoadState(), AuthenticatePageInvalidState()],
    );
    blocTest<AuthenticatePageCubit, AAuthenticatePageState>(
      'Should return a [AuthenticatePageLoadState,AuthenticatePageErrorState] as User attempts to verify a pin, when there is no authentication setup',

      // Arrange
      build: AuthenticatePageCubit.new,

      // Act
      act: (AuthenticatePageCubit authenticatePageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{'is_authenticated': 'false'});

        await authenticatePageCubit.verifyAuthentication(pin: '0000');
      },

      // Assert
      expect: () => <AAuthenticatePageState>[AuthenticatePageLoadState(), AuthenticatePageErrorState()],
    );
  });
}
