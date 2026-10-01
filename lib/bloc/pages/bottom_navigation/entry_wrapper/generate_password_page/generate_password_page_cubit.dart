import 'dart:async';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/password_length_type.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/password_security_level.dart';

class GeneratePasswordPageCubit extends Cubit<GeneratePasswordPageState> {
  static const int minCustomPasswordLength = 4;
  static const int maxCustomPasswordLength = 256;

  static const List<PasswordLengthType> _asciiPasswordLengthOptions = <PasswordLengthType>[
    PasswordLengthType.good,
    PasswordLengthType.excellent,
    PasswordLengthType.superb,
    PasswordLengthType.custom,
  ];
  static const List<PasswordLengthType> _sip2PasswordLengthOptions = <PasswordLengthType>[
    PasswordLengthType.good,
    PasswordLengthType.custom,
  ];

  GeneratePasswordPageCubit({required bool obscurePasswordBool}) : super(GeneratePasswordPageState.initial(obscurePasswordBool: obscurePasswordBool));

  Future<void> init() async {
    generatePassword();
  }

  void changeCharacterSet(CharacterSetType characterSetType) {
    if (state.characterSetType == characterSetType) {
      return;
    }

    List<PasswordLengthType> passwordLengthOptions = _getPasswordLengthOptions(characterSetType);
    PasswordLengthType passwordLengthType = passwordLengthOptions.contains(state.passwordLengthType)
        ? state.passwordLengthType
        : _getDefaultPasswordLengthType(characterSetType);

    emit(
      state.copyWith(
        characterSetType: characterSetType,
        passwordLengthType: passwordLengthType,
        passwordLengthOptions: passwordLengthOptions,
      ),
    );
    generatePassword();
  }

  void changePasswordLengthType(PasswordLengthType passwordLengthType) {
    PasswordLengthType nextPasswordLengthType = state.passwordLengthOptions.contains(passwordLengthType)
        ? passwordLengthType
        : _getDefaultPasswordLengthType(state.characterSetType);

    if (nextPasswordLengthType == PasswordLengthType.custom) {
      selectCustomPasswordLength();
      return;
    }

    if (state.passwordLengthType == nextPasswordLengthType) {
      return;
    }

    emit(state.copyWith(passwordLengthType: nextPasswordLengthType));
    generatePassword();
  }

  void updateCustomPasswordLengthText(String text) {
    if (state.customPasswordLengthText == text) {
      return;
    }

    emit(state.copyWith(customPasswordLengthText: text));
  }

  void selectCustomPasswordLength() {
    if (state.passwordLengthType == PasswordLengthType.custom) {
      return;
    }

    emit(state.copyWith(passwordLengthType: PasswordLengthType.custom));
  }

  void applyCustomPasswordLength() {
    if (state.passwordLengthType != PasswordLengthType.custom) {
      return;
    }

    if (_isCustomPasswordLengthValid(state.customPasswordLengthText) == false) {
      emit(state.copyWith(passwordLengthType: _getDefaultPasswordLengthType(state.characterSetType)));
      generatePassword();

      return;
    }

    int customPasswordLength = _clampCustomPasswordLength(state.customPasswordLengthText);
    if (state.passwordLengthType == PasswordLengthType.custom && state.passwordLength == customPasswordLength) {
      return;
    }

    emit(state.copyWith(passwordLengthType: PasswordLengthType.custom));
    generatePassword();
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePasswordBool: !state.obscurePasswordBool));
  }

  void generatePassword() {
    print('Suchar: generate password');
    int passwordLength = _getPasswordLength();
    PasswordGenerator passwordGenerator = _getPasswordGenerator();
    Password password = passwordGenerator.generate(passwordLength);
    double entropy = password.entropy;

    emit(
      state.copyWith(
        password: password.password,
        passwordEntropy: entropy,
        passwordLength: password.password.length,
        checksumCharacterCount: password.checksumCharacterCount,
        passwordSecurityLevel: _getPasswordSecurityLevel(entropy),
      ),
    );
  }

  PasswordSecurityLevel _getPasswordSecurityLevel(double entropy) {
    if (entropy < 80) {
      return PasswordSecurityLevel.unsafe;
    }

    if (entropy < 112) {
      return PasswordSecurityLevel.weak;
    }

    if (entropy < 128) {
      return PasswordSecurityLevel.good;
    }

    if (entropy < 256) {
      return PasswordSecurityLevel.excellent;
    }

    return PasswordSecurityLevel.superb;
  }

  int _getPasswordLength() {
    switch (state.passwordLengthType) {
      case PasswordLengthType.good:
      case PasswordLengthType.excellent:
      case PasswordLengthType.superb:
        return state.passwordLengthType.defaultLength!;
      case PasswordLengthType.custom:
        return _clampCustomPasswordLength(state.customPasswordLengthText);
    }
  }

  int _clampCustomPasswordLength(String text) {
    int? passwordLength = int.tryParse(text);
    if (passwordLength == null) {
      return PasswordLengthType.excellent.defaultLength!;
    }

    return passwordLength.clamp(minCustomPasswordLength, maxCustomPasswordLength);
  }

  bool _isCustomPasswordLengthValid(String text) {
    int? passwordLength = int.tryParse(text);
    if (passwordLength == null) {
      return false;
    }

    return passwordLength >= minCustomPasswordLength && passwordLength <= maxCustomPasswordLength;
  }

  PasswordGenerator _getPasswordGenerator() {
    switch (state.characterSetType) {
      case CharacterSetType.ascii:
        return PasswordGenerator.ascii();
      case CharacterSetType.sip2:
        return PasswordGenerator.sip2();
    }
  }

  PasswordLengthType _getDefaultPasswordLengthType(CharacterSetType characterSetType) {
    switch (characterSetType) {
      case CharacterSetType.ascii:
        return PasswordLengthType.excellent;
      case CharacterSetType.sip2:
        return PasswordLengthType.good;
    }
  }

  List<PasswordLengthType> _getPasswordLengthOptions(CharacterSetType characterSetType) {
    switch (characterSetType) {
      case CharacterSetType.ascii:
        return _asciiPasswordLengthOptions;
      case CharacterSetType.sip2:
        return _sip2PasswordLengthOptions;
    }
  }
}
