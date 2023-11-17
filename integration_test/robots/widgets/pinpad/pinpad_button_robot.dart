import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test/utils/test_utils.dart';

class PinpadButtonRobot {
  final WidgetTester widgetTester;
  const PinpadButtonRobot(this.widgetTester);

  Future<void> enterPins({required String pin}) async {
    for (int i = 0; i < pin.length; i++) {
      // Arrange
      final Finder findButton = find.byKey(Key('pinpad_button_${pin[i]}'));
      Offset buttonPosition = widgetTester.getCenter(findButton);

      // Assert
      TestUtils.printInfo('Should return true if expected Pinpad button exists in the screen');
      expect(findButton, findsOneWidget);

      // Act
      await widgetTester.tapAt(buttonPosition);
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> enterPinsPosition({required String key}) async {
    // Arrange
    final Finder findPinpadButton = find.byKey(Key(key));
    Offset pinpadButtonPosition = widgetTester.getCenter(findPinpadButton);

    for (int i = 0; i < 4; i++) {
      await widgetTester.tapAt(pinpadButtonPosition);
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> tapBackspaceButton({required int count}) async {
    for (int i = 0; i < count; i++) {
      // Arrange
      final Finder findButton = find.byKey(const Key('pinpad_backspace_button'));
      Offset buttonPosition = widgetTester.getCenter(findButton);

      // Assert
      TestUtils.printInfo('Should return true if expected Pinpad button exists in the screen');
      expect(findButton, findsOneWidget);

      // Act
      await widgetTester.tapAt(buttonPosition);
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }
}
