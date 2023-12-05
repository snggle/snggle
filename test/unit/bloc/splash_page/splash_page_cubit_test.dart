import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/splash_page/splash_page_cubit.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_ignore_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';

void main() {
  initLocator();

  group('Tests of SplashPage States', () {
    test('Should return initial state of [SplashPageLoadingState]', () {
      // Arrange
      SplashPageCubit splashPageCubit = SplashPageCubit();

      // Assert
      expect(splashPageCubit.state, SplashPageLoadingState());
    });

    blocTest<SplashPageCubit, ASplashPageState>(
      'Should return a [SplashPageErrorState] if [init] method fails. In this case, it fails because FlutterSecureStorage is not being initialized',
      // Arrange
      build: () {
        return SplashPageCubit();
      },

      // Act
      act: (SplashPageCubit splashPageCubit) async {
        await splashPageCubit.init();
      },

      // Assert
      expect: () => <ASplashPageState>[SplashPageErrorState()],
    );

    blocTest<SplashPageCubit, ASplashPageState>(
      'Should return a [SplashPageSetupPinState] at initial launch as user is navigated to Setup',
      // Arrange
      build: () {
        FlutterSecureStorage.setMockInitialValues(<String, String>{});
        return SplashPageCubit();
      },

      // Act
      act: (SplashPageCubit splashPageCubit) async {
        await splashPageCubit.init();
      },

      // Assert
      expect: () => <ASplashPageState>[SplashPageSetupPinState()],
    );

    blocTest<SplashPageCubit, ASplashPageState>(
      'Should return a [SplashPageIgnorePinState] as user decides to setup later, hence [setupPinVisibleBool] is set to false',
      // Arrange
      build: () {
        // @formatter:off
        FlutterSecureStorage.setMockInitialValues(<String, String>{
          DatabaseParentKey.encryptedMasterKey.name: 'Hr7afkeYIZeUWGvYsFEMorVcFSpr2ehXJ8ncwa1XTL71Q39Dl2LLciHKmaqs4YZqMiceOG3uBSHSyt6JP0F4yKJTWh2Ykrc00aHN/Ui58aNaXkyi7FLYbThHj0t2and/25D3XA==',
        });
        // @formatter:on
        return SplashPageCubit();
      },

      // Act
      act: (SplashPageCubit splashPageCubit) async {
        await splashPageCubit.init();
      },

      // Assert
      expect: () => <ASplashPageState>[SplashPageIgnorePinState()],
    );
  });
}
