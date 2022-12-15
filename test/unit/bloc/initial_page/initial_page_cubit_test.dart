import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/bloc/initial_page/initial_page_cubit.dart';
import 'package:snuggle/config/locator.dart';

void main() {
  initLocator();

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });
  group('Tests of InitialPage States: ', () {
    InitialPageCubit initialPageCubit = InitialPageCubit();

    test('Should return initial state of [InitialPageInitialState]', () {
      // Assert
      expect(initialPageCubit.state, InitialPageInitialState());
    });
    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return a [InitialPageErrorState] as this is the first launch of the App and no database exists',
      // Arrange
      build: () => initialPageCubit,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        await initialPageCubit.isAuthenticationSetup();
      },
      // Assert
      expect: () => <AInitialPageState>[InitialPageErrorState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return [InitialPageNoAuthenticationState] as user has decided to setup later',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{'setup_pin_page': 'false', 'is_authenticated': 'false'});
        await initialPageCubit.isAuthenticationSetup();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageNoAuthenticationState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return a [InitialPageSetupAuthenticationState] as user setup a pin already, and no longer needs to visit Setup PinPage again',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'setup_pin_page': 'false',
          'is_authenticated': 'true',
          'encrypted_hash_mnemonic': 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==',
        });
        await initialPageCubit.isAuthenticationSetup();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageAuthenticateState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return a [InitialPageErrorState] as user has decided to setup later. However, the database has failed to create all the fields and setup them up',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{'setup_pin_page': 'false'});
        await initialPageCubit.isAuthenticationSetup();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageErrorState()],
    );
  });
}
