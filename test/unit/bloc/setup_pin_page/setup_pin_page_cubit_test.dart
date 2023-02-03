import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/setup_pin_page/setup_pin_page_cubit.dart';
import 'package:snggle/bloc/setup_pin_page/states/setup_pin_page_confirm_state.dart';
import 'package:snggle/bloc/setup_pin_page/states/setup_pin_page_fail_state.dart';
import 'package:snggle/bloc/setup_pin_page/states/setup_pin_page_init_state.dart';
import 'package:snggle/bloc/setup_pin_page/states/setup_pin_page_later_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_controller.dart';

void main() {
  initLocator();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of SetupPinPage States: ', () {
    // Arrange
    PinpadController confirmPinpadController = PinpadController(pinpadTextFieldsSize: 4);
    PinpadController setupPinpadController = PinpadController(pinpadTextFieldsSize: 4);

    SetupPinPageCubit actualSetupPinpadPageCubit = SetupPinPageCubit(
      setupPinpadController: setupPinpadController,
      confirmPinpadController: confirmPinpadController,
    );

    test('Should return initial state of [SetupPinPageInitState]', () {
      // Assert
      expect(actualSetupPinpadPageCubit.state, SetupPinPageInitState());
    });

    test('Should return state of [SetupPinPageLaterState], after user decides to to setup later', () async {
      // Act
      await actualSetupPinpadPageCubit.setupLater();
      // Assert
      expect(actualSetupPinpadPageCubit.state, SetupPinPageLaterState());
    });

    blocTest<SetupPinPageCubit, ASetupPinPageState>(
      'Should return a [SetupPinPageConfirmState] after user has setup a pin in [SetupPinPageSetupState]',

      // Arrange
      build: () => SetupPinPageCubit(
        setupPinpadController: setupPinpadController,
        confirmPinpadController: confirmPinpadController,
      ),

      // Act
      act: (SetupPinPageCubit setupPinPageCubit) {
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[0].textEditingController.text = '0';
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[1].textEditingController.text = '0';
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[2].textEditingController.text = '0';
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[3].textEditingController.text = '0';
        setupPinPageCubit.updateState();
      },

      // Assert
      expect: () => <ASetupPinPageState>[SetupPinPageConfirmState()],
    );

    blocTest<SetupPinPageCubit, ASetupPinPageState>('Should return a [SetupPinPageSuccessState] from [SetupPinPageConfirmState] after user setups and confirms a pin',

        // Arrange
        build: () => SetupPinPageCubit(
              setupPinpadController: setupPinpadController,
              confirmPinpadController: confirmPinpadController,
            ),
        // Act
        act: (SetupPinPageCubit setupPinPageCubit) {
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[0].textEditingController.text = '0';
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[1].textEditingController.text = '0';
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[2].textEditingController.text = '0';
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[3].textEditingController.text = '0';
          setupPinPageCubit.updateState();
          setupPinPageCubit.confirmPinpadController.pinpadTextFieldModelList[0].textEditingController.text = '0';
          setupPinPageCubit.confirmPinpadController.pinpadTextFieldModelList[1].textEditingController.text = '0';
          setupPinPageCubit.confirmPinpadController.pinpadTextFieldModelList[2].textEditingController.text = '0';
          setupPinPageCubit.confirmPinpadController.pinpadTextFieldModelList[3].textEditingController.text = '0';
          setupPinPageCubit.updateState();
        },

        // Assert
        expect: () => <ASetupPinPageState>[
              SetupPinPageConfirmState(),
            ]);

    blocTest<SetupPinPageCubit, ASetupPinPageState>('Should return [SetupPinPageFailState] from [SetupPinPageConfirmState] after user fails to confirm a pin',

        // Arrange
        build: () => SetupPinPageCubit(
              setupPinpadController: setupPinpadController,
              confirmPinpadController: confirmPinpadController,
            ),

        // Act
        act: (SetupPinPageCubit setupPinPageCubit) {
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[0].textEditingController.text = '0';
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[1].textEditingController.text = '0';
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[2].textEditingController.text = '0';
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[3].textEditingController.text = '0';
          setupPinPageCubit.updateState();
          setupPinPageCubit.confirmPinpadController.pinpadTextFieldModelList[0].textEditingController.text = '0';
          setupPinPageCubit.confirmPinpadController.pinpadTextFieldModelList[1].textEditingController.text = '0';
          setupPinPageCubit.confirmPinpadController.pinpadTextFieldModelList[2].textEditingController.text = '0';
          setupPinPageCubit.confirmPinpadController.pinpadTextFieldModelList[3].textEditingController.text = '1';
          setupPinPageCubit.updateState();
        },

        // Assert
        expect: () => <ASetupPinPageState>[
              SetupPinPageConfirmState(),
              SetupPinPageFailState(),
            ]);

    blocTest<SetupPinPageCubit, ASetupPinPageState>('Should return a [SetupPinPageInitState] from [SetupPinPageConfirmState] after user decides to cancel confirming a pin',

        // Arrange
        build: () => SetupPinPageCubit(
              setupPinpadController: setupPinpadController,
              confirmPinpadController: confirmPinpadController,
            ),

        // Act
        act: (SetupPinPageCubit setupPinPageCubit) {
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[0].textEditingController.text = '0';
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[1].textEditingController.text = '0';
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[2].textEditingController.text = '0';
          setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[3].textEditingController.text = '0';
          setupPinPageCubit
            ..updateState()
            ..cancelConfirmState();
        },

        // Assert
        expect: () => <ASetupPinPageState>[
              SetupPinPageConfirmState(),
              SetupPinPageInitState(),
            ]);
  });
}
