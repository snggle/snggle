import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/splash_page/splash_page_cubit.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/config/locator.dart';

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
  });
}
