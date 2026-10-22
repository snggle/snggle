import 'package:flutter/services.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_cubit.dart';

class CustomPasswordLengthInputFormatter extends TextInputFormatter {
  static const int _maxIndex = GeneratePasswordPageCubit.maxCustomPasswordLength;

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
