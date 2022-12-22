import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/bloc/initial_page/initial_page_cubit.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_initial_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_setup_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_skip_authenticate_state.dart';
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
      'Should return a [InitialPageSetupState] at initial launch as user is navigated to Setup',
      // Arrange
      build: () => initialPageCubit,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        await initialPageCubit.checkSetup();
      },
      // Assert
      expect: () => <AInitialPageState>[InitialPageSetupState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return a [InitialPageSkipAuthenticationState] when setup is already done before.',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{'setup': 'false'});
        await initialPageCubit.checkSetup();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageSkipAuthenticationState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return [InitialPageSkipAuthenticationState] as user decided to setup later',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{'setup': 'false', 'is_authenticated': 'false'});
        await initialPageCubit.checkSetup();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageSkipAuthenticationState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return a [InitialPageSkipAuthenticationState] as user setup a pin already, and no longer needs to visit Setup PinPage again',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'setup': 'false',
          'is_authenticated': 'true',
          'hash_mnemonic': 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==',
        });
        await initialPageCubit.checkSetup();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageSkipAuthenticationState()],
    );
  });
}
