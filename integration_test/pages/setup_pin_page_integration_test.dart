import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snuggle/main.dart' as app;

import '../../test/utils/test_utils.dart';
import '../robots/pages/setup_pin_page_robot.dart';
import '../robots/widgets/pinpad/pinpad_button_robot.dart';
import '../robots/widgets/pinpad/pinpad_text_fields_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tests of hiding pinpadTextFields by clicking Obscure Icon Button:', () {
    testWidgets('Should return true, as by default pinpadTextFields are hidden', (WidgetTester widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();

      PinpadTextFieldsRobot pinpadTextFieldsRobot = PinpadTextFieldsRobot(widgetTester);

      await pinpadTextFieldsRobot.validateObscurePinpadTextField(obscure: true);
    });

    testWidgets(
      'Should return true, after showing and hiding PinpadTextFields [which changes icons]',
      (WidgetTester widgetTester) async {
        app.main();
        await widgetTester.pumpAndSettle();

        PinpadTextFieldsRobot pinpadTextFieldsRobot = PinpadTextFieldsRobot(widgetTester);

        TestUtils.printInfo('Should return true as by default PinpadTextFields are obscured/hidden');
        await pinpadTextFieldsRobot.validateObscurePinpadTextField(obscure: true);

        // *********************************************************************

        await pinpadTextFieldsRobot.showPinpadTextFields();
        TestUtils.printInfo('Should return false, as by PinpadTextFields values are made visible after clicking Obscure (show) Icon button');
        await pinpadTextFieldsRobot.validateObscurePinpadTextField(obscure: false);

        // *********************************************************************

        await pinpadTextFieldsRobot.hidePinpadTextFields();

        TestUtils.printInfo('Should return true, as by PinpadTextFields values are made hidden after clicking Obscure (hide) Icon button');

        await pinpadTextFieldsRobot.validateObscurePinpadTextField(obscure: true);
      },
    );
  });

  group('Tests of PinpadButtons and their value:', () {
    testWidgets(
      'Should return true after pins are entered [not Shuffled mode], and equal to 1111',
      (WidgetTester widgetTester) async {
        app.main();
        await widgetTester.pumpAndSettle();

        PinpadButtonRobot pinpadButtonRobot = PinpadButtonRobot(widgetTester);
        PinpadTextFieldsRobot pinpadTextFieldsRobot = PinpadTextFieldsRobot(widgetTester);

        await pinpadTextFieldsRobot.showPinpadTextFields();
        await pinpadButtonRobot.enterPins(pin: '1111');
        await pinpadTextFieldsRobot.validateCorrectPin(pin: '1111');
      },
    );
    testWidgets(
      'Should return false after pins are entered [Shuffled mode], and not equal to 1111',
      (WidgetTester widgetTester) async {
        app.main();
        await widgetTester.pumpAndSettle();

        PinpadButtonRobot pinpadButtonRobot = PinpadButtonRobot(widgetTester);
        PinpadTextFieldsRobot pinpadTextFieldsRobot = PinpadTextFieldsRobot(widgetTester);
        SetupPinPageRobot shuffleSwitch = SetupPinPageRobot(widgetTester);

        await pinpadTextFieldsRobot.showPinpadTextFields();
        await shuffleSwitch.tapShuffleSwitchButton();
        await pinpadButtonRobot.enterPinsPosition(key: 'pinpad_button_1');
        await pinpadTextFieldsRobot.validateFalsePin(pin: '1111');
      },
    );
  });

  group('Tests of Shuffling PinpadButtons by Switch Button', () {
    testWidgets(
      'Should return false as by default PinpadButtons are not shuffled',
      (WidgetTester widgetTester) async {
        app.main();
        await widgetTester.pumpAndSettle();

        SetupPinPageRobot shuffleSwitch = SetupPinPageRobot(widgetTester);

        await shuffleSwitch.validateShuffleEnabled(isShuffled: false);
      },
    );

    testWidgets(
      'Should return true as switch button is used to shuffle',
      (WidgetTester widgetTester) async {
        app.main();
        await widgetTester.pumpAndSettle();

        SetupPinPageRobot shuffleSwitch = SetupPinPageRobot(widgetTester);

        await shuffleSwitch.tapShuffleSwitchButton();
        await shuffleSwitch.validateShuffleEnabled(isShuffled: true);
      },
    );

    group('Tests of authenticating Pins entered via PinpadButtons', () {
      testWidgets(
        'Should return true after user enter pins and is able to confirm it successfully',
        (WidgetTester widgetTester) async {
          app.main();
          await widgetTester.pumpAndSettle();

          PinpadButtonRobot pinpadButtonRobot = PinpadButtonRobot(widgetTester);
          PinpadTextFieldsRobot pinpadTextFieldsRobot = PinpadTextFieldsRobot(widgetTester);
          SetupPinPageRobot setupPinRobot = SetupPinPageRobot(widgetTester);

          await pinpadTextFieldsRobot.showPinpadTextFields();
          await pinpadButtonRobot.enterPins(pin: '1111');
          await setupPinRobot.tapNextButton();

          await pinpadButtonRobot.enterPins(pin: '1111');
          await setupPinRobot.tapConfirmButton();
        },
      );

      testWidgets(
        'Should return false after user enter pins and fails to confirm it correctly, and warning message appears',
        (WidgetTester widgetTester) async {
          app.main();
          await widgetTester.pumpAndSettle();

          PinpadButtonRobot pinpadButtonRobot = PinpadButtonRobot(widgetTester);
          PinpadTextFieldsRobot pinpadTextFieldsRobot = PinpadTextFieldsRobot(widgetTester);
          SetupPinPageRobot setupPinRobot = SetupPinPageRobot(widgetTester);

          await pinpadTextFieldsRobot.showPinpadTextFields();
          await pinpadButtonRobot.enterPins(pin: '1111');
          await setupPinRobot.tapNextButton();

          await setupPinRobot.tapShuffleSwitchButton();
          await pinpadButtonRobot.enterPinsPosition(key: 'pinpad_button_1');
          await setupPinRobot.tapConfirmButton();

          await setupPinRobot.validateIncorrectPinWarningVisible();
        },
      );

      testWidgets(
        'Should return true with value 1111 after pins are entered [not shuffled mode], remove is pressed once',
        (WidgetTester widgetTester) async {
          app.main();
          await widgetTester.pumpAndSettle();

          PinpadButtonRobot pinpadButtonRobot = PinpadButtonRobot(widgetTester);
          PinpadTextFieldsRobot pinpadTextFieldsRobot = PinpadTextFieldsRobot(widgetTester);

          await pinpadTextFieldsRobot.showPinpadTextFields();
          await pinpadButtonRobot.enterPins(pin: '1111');
          await pinpadButtonRobot.tapBackspaceButton(count: 4);
          await pinpadTextFieldsRobot.validateCorrectPin(pin: '');
        },
      );
      testWidgets(
        'Should return true if User clicks on Setup Later',
        (WidgetTester widgetTester) async {
          app.main();
          await widgetTester.pumpAndSettle();

          SetupPinPageRobot setupPinRobot = SetupPinPageRobot(widgetTester);

          await setupPinRobot.tapSetupLaterButton();
        },
      );
    });
  });
}
