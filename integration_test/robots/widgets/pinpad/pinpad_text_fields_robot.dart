import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test/utils/test_utils.dart';

class PinpadTextFieldsRobot {
  final WidgetTester widgetTester;
  const PinpadTextFieldsRobot(this.widgetTester);

  Future<void> validateCorrectPin({required String pin}) async {
    // Arrange
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < 4; i++) {
      final Finder findPinpadTextField = find.byKey(Key('pinpad_text_field_$i'));

      // Assert
      TestUtils.printInfo('Should return true if the expected PinpadTextField exists in the screen');
      expect(findPinpadTextField, findsOneWidget);

      TextField pinpadTextFieldWidget = widgetTester.firstWidget<TextField>(findPinpadTextField);
      buffer.write(pinpadTextFieldWidget.controller!.text);
    }
    expect(buffer.toString(), pin);
  }

  Future<void> validateFalsePin({required String pin}) async {
    // Arrange
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < 4; i++) {
      final Finder findPinpadTextField = find.byKey(Key('pinpad_text_field_$i'));

      // Assert
      TestUtils.printInfo('Should return true if the expected PinpadTextField exists in the screen');
      expect(findPinpadTextField, findsOneWidget);

      TextField pinpadTextFieldWidget = widgetTester.firstWidget<TextField>(findPinpadTextField);
      buffer.write(pinpadTextFieldWidget.controller!.text);
    }
    expect(buffer.toString(), isNot(pin));
  }

  Future<void> validateObscurePinpadTextField({required bool obscure}) async {
    // Arrange
    final Finder findPinpadTextField = find.byKey(const Key('pinpad_text_field_0'));

    // Assert
    TestUtils.printInfo('Should return true if the expected PinpadTextField exists in the screen');
    expect(findPinpadTextField, findsOneWidget);

    TextField pinpadTextFieldWidget = widgetTester.firstWidget<TextField>(findPinpadTextField);

    return expect(pinpadTextFieldWidget.obscureText, obscure);
  }

  Future<void> hidePinpadTextFields() async {
    // Arrange
    final Finder findHideShuffleSwitch = find.byIcon(Icons.visibility_off);

    // Assert
    TestUtils.printInfo('Should return true if obscure button (hide) exists in the screen');
    expect(findHideShuffleSwitch, findsOneWidget);

    // Act
    await widgetTester.tap(findHideShuffleSwitch);
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  Future<void> showPinpadTextFields() async {
    // Arrange
    final Finder findShowShuffleSwitch = find.byIcon(Icons.visibility);

    // Assert
    TestUtils.printInfo('Should return true if obscure (show) button exists in the screen');
    expect(findShowShuffleSwitch, findsOneWidget);

    // Act
    await widgetTester.tap(findShowShuffleSwitch);
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}
