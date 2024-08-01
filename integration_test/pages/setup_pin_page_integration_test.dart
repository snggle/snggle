import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snggle/main.dart' as app;

import '../../test/utils/test_utils.dart';
import '../robots/widgets/pinpad/pinpad_text_fields_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tests of hiding pinpadTextFields by clicking Obscure Icon Button:', () {
    testWidgets('Should return true, after showing and hiding PinpadTextFields [which changes icons]', (WidgetTester widgetTester) async {
      await app.main();
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
    });
  });
}
