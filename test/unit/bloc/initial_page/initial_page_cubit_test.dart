import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/bloc/initial_page/initial_page_cubit.dart';
import 'package:snuggle/config/locator.dart';

void main() {
  initLocator();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });
  group('Tests of InitialPage States: ', () {
    InitialPageCubit initialPageCubit = InitialPageCubit();

    test('Should return initial state of [InitialPageInitialState]', () {
      // Assert
      expect(initialPageCubit.state, InitialPageInitialState());
    });
    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return a [InitialPageSetupAuthenticationState] as this is the first launch of the App and no database exists',
      // Arrange
      build: () => initialPageCubit,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        await initialPageCubit.isIntroductionSetup();
      },
      // Assert
      expect: () => <AInitialPageState>[InitialPageSetupAuthenticationState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return [InitialPageNoAuthenticationState] as user has decided to setup later',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{'setup_pin_page': 'false', 'is_authenticated': 'false'});
        await initialPageCubit.isIntroductionSetup();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageNoAuthenticationState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return a [InitialPageAuthenticateState] as user setup a pin already, and no longer needs to visit Setup PinPage again',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'setup_pin_page': 'false',
          'is_authenticated': 'true',
          'hash_mnemonic': 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==',
        });
        await initialPageCubit.isIntroductionSetup();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageAuthenticateState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return a [InitialPageNoAuthenticationState] as user has decided to setup later.',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{'setup_pin_page': 'false'});
        await initialPageCubit.isIntroductionSetup();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageNoAuthenticationState()],
    );
  });
}
