import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snuggle/bloc/initial_page/initial_page_cubit.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_initial_setup_visible_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_initial_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_skip_authentication_state.dart';
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
      'Should return a [InitialPageInitialSetupVisibleState] at initial launch as user is navigated to Setup',
      // Arrange
      build: () => initialPageCubit,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        await initialPageCubit.checkInitialSetupVisibleState();
      },
      // Assert
      expect: () => <AInitialPageState>[InitialPageInitialSetupVisibleState()],
    );

    blocTest<InitialPageCubit, AInitialPageState>(
      'Should return a [InitialPageSkipAuthenticationState] as user decides to setup later, hence [is_initial_setup_visible] is set to false',
      // Arrange
      build: InitialPageCubit.new,

      // Act
      act: (InitialPageCubit initialPageCubit) async {
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          'is_initial_setup_visible': 'false',
          'hash_mnemonic': 'HjqvAkkyHxKxcrgueqt/LZenap6I5fjVGOsiAOqRGNcUwm67q6SONnGpWDmOiJdGDnJtVvpgS1o3qORTZs3Izzm3PAUGb0yDY3ZcfvwU9iFmHHfDjq+2Tk5DwdpnhWmoEHxDbg==',
        });
        await initialPageCubit.checkInitialSetupVisibleState();
      },

      // Assert
      expect: () => <AInitialPageState>[InitialPageSkipAuthenticationState()],
    );
  });
}
