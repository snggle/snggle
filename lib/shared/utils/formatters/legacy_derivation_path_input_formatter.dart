import 'package:flutter/services.dart';

class LegacyDerivationPathInputFormatter extends TextInputFormatter {
  static final BigInt _maxIndex = BigInt.parse('2147483647');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (newValue.text.startsWith('0') && newValue.text.length > 1) {
      return oldValue;
    }

    BigInt? intValue = BigInt.tryParse(newValue.text);
    if (intValue == null) {
      return oldValue;
    }

    if (intValue > _maxIndex) {
      return oldValue;
    }

    return newValue;
  }
}
