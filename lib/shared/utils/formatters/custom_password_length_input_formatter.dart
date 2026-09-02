import 'package:flutter/services.dart';

class CustomPasswordLengthInputFormatter extends TextInputFormatter {
  final int maximumLength;

  CustomPasswordLengthInputFormatter({required this.maximumLength});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    bool emptyValueBool = newValue.text.isEmpty;
    if (emptyValueBool) {
      return newValue;
    }

    bool invalidCharactersBool = RegExp(r'^[1-9][0-9]*$').hasMatch(newValue.text) == false;
    if (invalidCharactersBool) {
      return oldValue;
    }

    int? passwordLength = int.tryParse(newValue.text);
    bool invalidLengthBool = passwordLength == null || passwordLength > maximumLength;
    if (invalidLengthBool) {
      return oldValue;
    }

    return newValue;
  }
}
