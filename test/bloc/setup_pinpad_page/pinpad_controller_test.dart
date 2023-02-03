// ignore_for_file: cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_controller.dart';

import '../../utils/test_utils.dart';

void main() {

  group('Tests of methods addPin(), value getter and removePin()', () {
    test('Should return EMPTY STRINGS for Pinpad and selected Pinpad text-field after constructor init and removePin()', () {
      // Arrange
      PinpadController actualSetupPinpadController = PinpadController(pinpadTextFieldsSize: 4);

      // Act
      actualSetupPinpadController.removePin();

      // Assert
      expect(actualSetupPinpadController.value, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 0);
    });

    test('Should replicate whole path of inputting and removing numbers from Pinpad text-fields', () {
      // Arrange + Act
      PinpadController actualSetupPinpadController = PinpadController(pinpadTextFieldsSize: 4);

      // Assert
      TestUtils.printInfo('Should return EMPTY STRINGS for Pinpad and selected Pinpad text-field after constructor init');
      expect(actualSetupPinpadController.value, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 0);

      // *********************************************************************

      // Act
      actualSetupPinpadController.addPin(1);

      // Assert
      TestUtils.printInfo('Should return Pinpad = "1" and selected Pinpad text-field = "EMPTY STRING" after addPin(1)');
      expect(actualSetupPinpadController.value, '1');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 1);

      // *********************************************************************

      // Act
      actualSetupPinpadController.addPin(2);

      // Assert
      TestUtils.printInfo('Should return Pinpad = "12" and selected Pinpad text-field = "EMPTY STRING" after addPin(2)');
      expect(actualSetupPinpadController.value, '12');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 2);

      // *********************************************************************

      // Act
      actualSetupPinpadController.addPin(3);

      // Assert
      TestUtils.printInfo('Should return Pinpad = "123" and selected Pinpad text-field = "EMPTY STRING" after addPin(3)');
      expect(actualSetupPinpadController.value, '123');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 3);

      // *********************************************************************

      // Act
      actualSetupPinpadController.addPin(4);

      // Assert
      TestUtils.printInfo('Should return Pinpad = "1234" and selected Pinpad text-field = "4" after addPin(4)');
      expect(actualSetupPinpadController.value, '1234');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, '4');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 3);

      // *********************************************************************
      // *********************************************************************

      // Act
      actualSetupPinpadController.addPin(5);

      // Assert
      TestUtils.printInfo('Should return Pinpad = "1234" and selected Pinpad text-field = "4"  after addPin(5)');
      expect(actualSetupPinpadController.value, '1234');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, '4');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 3);

      // *********************************************************************
      // *********************************************************************

      // Act
      actualSetupPinpadController.removePin();

      // Assert
      TestUtils.printInfo('Should return Pinpad = "123" and selected Pinpad text-field = "EMPTY STRING" after removePin()');
      expect(actualSetupPinpadController.value, '123');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 3);

      // *********************************************************************

      // Act
      actualSetupPinpadController.removePin();

      // Assert
      TestUtils.printInfo('Should return Pinpad = "12" and selected Pinpad text-field = "EMPTY STRING" after removePin()');
      expect(actualSetupPinpadController.value, '12');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 2);

      // *********************************************************************

      // Act
      actualSetupPinpadController.removePin();

      // Assert
      TestUtils.printInfo('Should return Pinpad = "1" and selected Pinpad text-field = "EMPTY STRING" after removePin()');
      expect(actualSetupPinpadController.value, '1');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 1);

      // *********************************************************************

      // Act
      actualSetupPinpadController.removePin();

      // Assert
      TestUtils.printInfo('Should return EMPTY STRINGS for Pinpad and selected Pinpad text-field after removePin()');
      expect(actualSetupPinpadController.value, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 0);
    });
  });

  group('Tests of methods addPin(), value getter and clear()', () {
    test('Should replicate whole path of inputting and canceling(?) input from Pinpad text-fields', () {
      // Arrange
      PinpadController actualSetupPinpadController = PinpadController(pinpadTextFieldsSize: 4);

      // Assert
      TestUtils.printInfo('Should return EMPTY STRINGS for Pinpad and selected Pinpad text-field after constructor init');
      expect(actualSetupPinpadController.value, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 0);

      // *********************************************************************

      // Act
      actualSetupPinpadController.addPin(1);

      // Assert
      TestUtils.printInfo('Should return Pinpad = "1" and selected Pinpad text-field = "EMPTY STRING" after addPin(1)');

      expect(actualSetupPinpadController.value, '1');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 1);

      // *********************************************************************

      // Act
      actualSetupPinpadController.addPin(2);

      // Assert
      TestUtils.printInfo('Should return Pinpad = "12" and selected Pinpad text-field = "EMPTY STRING" after addPin(2)');
      expect(actualSetupPinpadController.value, '12');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 2);

      // *********************************************************************

      // Act
      actualSetupPinpadController.addPin(3);

      // Assert
      TestUtils.printInfo('Should return Pinpad = "123" and selected Pinpad text-field = "EMPTY STRING" after addPin(3)');
      expect(actualSetupPinpadController.value, '123');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 3);

      // *********************************************************************

      // Act
      actualSetupPinpadController.addPin(4);

      // Assert
      TestUtils.printInfo('Should return Pinpad = "1234" and selected Pinpad text-field = "4" after addPin(4)');
      expect(actualSetupPinpadController.value, '1234');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, '4');
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 3);

      // *********************************************************************
      // *********************************************************************

      // Act
      actualSetupPinpadController.clear();

      // Assert
      TestUtils.printInfo('Should return EMPTY STRINGS for Pinpad and selected Pinpad text-field after clear()');
      expect(actualSetupPinpadController.value, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.textEditingController.text, kEmptyString);
      expect(actualSetupPinpadController.selectedPinpadTextFieldModel.index, 0);
    });
  });
}
