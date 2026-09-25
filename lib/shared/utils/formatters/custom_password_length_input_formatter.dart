import 'package:flutter/services.dart';

class CustomPasswordLengthInputFormatter extends TextInputFormatter {
  static final int _maxIndex = int.parse('150');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (newValue.text.startsWith('0')) {
      return oldValue;
    }

    int? intValue = int.tryParse(newValue.text);
    if (intValue == null) {
      return oldValue;
    }

    if (intValue > _maxIndex) {
      return oldValue;
    }

    return newValue;
  }
}
