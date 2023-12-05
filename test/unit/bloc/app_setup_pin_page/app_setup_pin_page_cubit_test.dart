import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/app_setup_pin_page/app_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_confirm_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_init_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_invalid_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_setup_later_state.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_controller.dart';

void main() {
  initLocator();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  group('Tests of AppSetupPinPage States: ', () {
    // Arrange
    PinpadController confirmPinpadController = PinpadController(pinpadTextFieldsSize: 4);
    PinpadController setupPinpadController = PinpadController(pinpadTextFieldsSize: 4);

    AppSetupPinPageCubit actualAppSetupPinPageCubit = AppSetupPinPageCubit(
      setupPinpadController: setupPinpadController,
      confirmPinpadController: confirmPinpadController,
    );

    test('Should return initial state of [AppSetupPinPageInitState]', () {
      // Assert
      expect(actualAppSetupPinPageCubit.state, AppSetupPinPageInitState());
    });

    test('Should return state of [AppSetupPinPageSetupLaterState], after user decides to to setup later', () async {
      // Act
      await actualAppSetupPinPageCubit.setupLater();
      // Assert
      expect(actualAppSetupPinPageCubit.state, AppSetupPinPageSetupLaterState());
    });

    blocTest<AppSetupPinPageCubit, AAppSetupPinPageState>(
      'Should return a [AppSetupPinPageConfirmState] after user has setup a pin in [AppSetupPinPageInitState]',

      // Arrange
      build: () => AppSetupPinPageCubit(
        setupPinpadController: setupPinpadController,
        confirmPinpadController: confirmPinpadController,
      ),

      // Act
      act: (AppSetupPinPageCubit setupPinPageCubit) {
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[0].textEditingController.text = '0';
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[1].textEditingController.text = '0';
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[2].textEditingController.text = '0';
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[3].textEditingController.text = '0';
        setupPinPageCubit.updateState();
      },

      // Assert
      expect: () => <AAppSetupPinPageState>[
        AppSetupPinPageConfirmState(passwordModel: PasswordModel.fromPlaintext('0000')),
      ],
    );

    blocTest<AppSetupPinPageCubit, AAppSetupPinPageState>(
      'Should return a [AppSetupPinPageSuccessState] from [AppSetupPinPageConfirmState] after user setups and confirms a pin',

      // Arrange
      build: () => AppSetupPinPageCubit(
        setupPinpadController: setupPinpadController,
        confirmPinpadController: confirmPinpadController,
      ),
      // Act
      act: (AppSetupPinPageCubit setupPinPageCubit) {
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
      expect: () => <AAppSetupPinPageState>[
        AppSetupPinPageConfirmState(passwordModel: PasswordModel.fromPlaintext('0000')),
      ],
    );

    blocTest<AppSetupPinPageCubit, AAppSetupPinPageState>(
      'Should return [AppSetupPinPageFailState] from [AppSetupPinPageConfirmState] after user fails to confirm a pin',

      // Arrange
      build: () => AppSetupPinPageCubit(
        setupPinpadController: setupPinpadController,
        confirmPinpadController: confirmPinpadController,
      ),

      // Act
      act: (AppSetupPinPageCubit setupPinPageCubit) {
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
      expect: () => <AAppSetupPinPageState>[
        AppSetupPinPageConfirmState(passwordModel: PasswordModel.fromPlaintext('0000')),
        AppSetupPinPageInvalidState(passwordModel: PasswordModel.fromPlaintext('0000')),
      ],
    );

    blocTest<AppSetupPinPageCubit, AAppSetupPinPageState>(
      'Should return a [AppSetupPinPageInitState] from [AppSetupPinPageConfirmState] after user decides to cancel confirming a pin',

      // Arrange
      build: () => AppSetupPinPageCubit(
        setupPinpadController: setupPinpadController,
        confirmPinpadController: confirmPinpadController,
      ),

      // Act
      act: (AppSetupPinPageCubit setupPinPageCubit) {
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[0].textEditingController.text = '0';
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[1].textEditingController.text = '0';
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[2].textEditingController.text = '0';
        setupPinPageCubit.setupPinpadController.pinpadTextFieldModelList[3].textEditingController.text = '0';
        setupPinPageCubit
          ..updateState()
          ..cancelConfirmState();
      },

      // Assert
      expect: () => <AAppSetupPinPageState>[
        AppSetupPinPageConfirmState(passwordModel: PasswordModel.fromPlaintext('0000')),
        AppSetupPinPageInitState(),
      ],
    );
  });
}
