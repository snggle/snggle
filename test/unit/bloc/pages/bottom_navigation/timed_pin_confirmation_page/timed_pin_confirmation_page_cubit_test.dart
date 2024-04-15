import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/a_timed_pin_confirmation_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/states/timed_pin_confirmation_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/states/timed_pin_confirmation_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/timed_pin_confirmation_page_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/database_parent_key.dart';
import 'package:snggle/shared/exceptions/invalid_password_exception.dart';

Future<void> main() async {
  initLocator();

  late TimedPinConfirmationPageCubit actualTimedPinConfirmationPageCubit;

  // @formatter:off
  Map<String, String> filledMasterKeyDatabase = <String, String>{
    DatabaseParentKey.encryptedMasterKey.name: '49KzNRK6zoqQArJHTHpVB+nsq60XbRqzddQ8C6CSvasVDPS4+Db+0tUislsx6WaraetLiZ2QXCulvbK6nmaHXpnPwHLK1FYvq11PpLWiAUlVF/KW+omOhD9bQFPIboxLxTnfsg==',
  };
  // @formatter:on

  group('Tests of [TimedPinConfirmationPageCubit]', () {
    group('Tests of [TimedPinConfirmationPageCubit] when [pin CORRECT]', () {
      setUpAll(() {
        actualTimedPinConfirmationPageCubit = TimedPinConfirmationPageCubit();
        FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));
      });

      test('Should [emit TimedPinConfirmationPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        ATimedPinConfirmationPageState expectedTimedPinConfirmationPageState = TimedPinConfirmationPageEnterPinState.empty();

        expect(actualTimedPinConfirmationPageCubit.state, expectedTimedPinConfirmationPageState);
      });

      test('Should [emit TimedPinConfirmationPageEnterPinState] with [FILLED pinNumbers]', () async {
        // Act
        actualTimedPinConfirmationPageCubit.updatePinNumbers(const <int>[1, 1, 1, 1]);

        // Assert
        ATimedPinConfirmationPageState expectedTimedPinConfirmationPageState = const TimedPinConfirmationPageEnterPinState(pinNumbers: <int>[1, 1, 1, 1]);

        expect(actualTimedPinConfirmationPageCubit.state, expectedTimedPinConfirmationPageState);
      });

      test('Should [setup pinNumbers] as an app password in [AuthSingletonCubit]', () async {
        // Act
        await actualTimedPinConfirmationPageCubit.authenticate();

        // Assert
        ATimedPinConfirmationPageState expectedTimedPinConfirmationPageState = const TimedPinConfirmationPageEnterPinState(pinNumbers: <int>[1, 1, 1, 1]);

        expect(actualTimedPinConfirmationPageCubit.state, expectedTimedPinConfirmationPageState);
      });
    });

    group('Tests of [TimedPinConfirmationPageCubit] when [pin INCORRECT]', () {
      setUpAll(() {
        actualTimedPinConfirmationPageCubit = TimedPinConfirmationPageCubit();
        FlutterSecureStorage.setMockInitialValues(Map<String, String>.from(filledMasterKeyDatabase));
      });

      test('Should [emit TimedPinConfirmationPageEnterPinState] with [EMPTY pinNumbers] as initial state', () async {
        // Assert
        ATimedPinConfirmationPageState expectedTimedPinConfirmationPageState = TimedPinConfirmationPageEnterPinState.empty();

        expect(actualTimedPinConfirmationPageCubit.state, expectedTimedPinConfirmationPageState);
      });

      test('Should [emit TimedPinConfirmationPageEnterPinState] with [FILLED pinNumbers]', () async {
        // Act
        actualTimedPinConfirmationPageCubit.updatePinNumbers(const <int>[9, 9, 9, 9]);

        // Assert
        ATimedPinConfirmationPageState expectedTimedPinConfirmationPageState = const TimedPinConfirmationPageEnterPinState(pinNumbers: <int>[9, 9, 9, 9]);

        expect(actualTimedPinConfirmationPageCubit.state, expectedTimedPinConfirmationPageState);
      });

      test('Should [emit TimedPinConfirmationPageInvalidPinState] and throw [InvalidPasswordException]', () async {
        try {
          // Act
          await actualTimedPinConfirmationPageCubit.authenticate();
        } catch (actualException) {
          // Assert
          ATimedPinConfirmationPageState expectedTimedPinConfirmationPageState = const TimedPinConfirmationPageInvalidPinState(pinNumbers: <int>[9, 9, 9, 9]);

          expect(actualException, isA<InvalidPasswordException>());
          expect(actualTimedPinConfirmationPageCubit.state, expectedTimedPinConfirmationPageState);
        }
      });
    });
  });
}
