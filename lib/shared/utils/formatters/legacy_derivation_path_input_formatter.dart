import 'package:flutter/services.dart';

class LegacyDerivationPathInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }

  static bool hasMatch(String input) {
    if (input == '/') {
      return false;
    }
    RegExp regExp = RegExp(r"^(\d+(')?(/(\d+(')?))*)?/?$");
    return regExp.hasMatch(input);
  }
}
