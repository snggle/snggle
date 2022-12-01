import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test/utils/test_utils.dart';

class SetupPinPageRobot {
  final WidgetTester widgetTester;
  const SetupPinPageRobot(this.widgetTester);

  Future<void> tapNextButton() async {
    // Arrange
    final Finder nextButton = find.text('Next');

    TestUtils.printInfo('Should return true if Next button exists in the screen');

    // Assert
    expect(nextButton, findsOneWidget);

    // Act
    await widgetTester.tap(nextButton);
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  Future<void> tapConfirmButton() async {
    // Arrange
    final Finder nextButton = find.text('Confirm');

    TestUtils.printInfo('Should return true if Confirm button exists in the screen');

    // Assert
    expect(nextButton, findsOneWidget);

    // Act
    await widgetTester.tap(nextButton);
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  Future<void> tapSetupLaterButton() async {
    // Arrange
    final Finder findSetupLater = find.text('Setup Later');

    TestUtils.printInfo('Should return true if Setup Later Button exists in the screen');

    // Assert
    expect(findSetupLater, findsOneWidget);

    // Act
    await widgetTester.tap(findSetupLater);
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  Future<void> tapShuffleSwitchButton() async {
    // Arrange
    final Finder findShuffleSwitch = find.byKey(const Key('shuffle_switch'));

    // Assert
    TestUtils.printInfo('Should return true if shuffle Switch button exists in the screen');
    expect(findShuffleSwitch, findsOneWidget);

    // Act
    await widgetTester.tap(findShuffleSwitch);
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  Future<void> validateIncorrectPinWarningVisible() async {
    // Arrange
    final Finder findIncorrectWarningMessage = find.text('Incorrect pin, try again');

    // Assert
    TestUtils.printInfo('Should return true if Incorrect pin warning message exists in the screen');
    expect(findIncorrectWarningMessage, findsOneWidget);
  }

  Future<bool> validateShuffleEnabled({required bool isShuffled}) async {
    // Arrange
    final Finder findShuffleSwitch = find.byKey(const Key('shuffle_switch'));

    // Assert
    TestUtils.printInfo('Should return true if shuffle switch button exists in the screen');
    expect(findShuffleSwitch, findsOneWidget);

    // Act
    Switch shuffleSwitchWidget = widgetTester.firstWidget<Switch>(findShuffleSwitch);
    return shuffleSwitchWidget.value;
  }
}
