import 'dart:async';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/password_level_type.dart';

class GeneratePasswordPageCubit extends Cubit<GeneratePasswordPageState> {
  static const int minCustomPasswordLength = 4;
  static const int maxCustomPasswordLength = 256;

  static const List<PasswordLevelType> _asciiPasswordLengthOptions = <PasswordLevelType>[
    PasswordLevelType.good,
    PasswordLevelType.excellent,
    PasswordLevelType.magnificent,
    PasswordLevelType.custom,
  ];
  static const List<PasswordLevelType> _sip2PasswordLengthOptions = <PasswordLevelType>[
    PasswordLevelType.good,
    PasswordLevelType.custom,
  ];

  GeneratePasswordPageCubit() : super(GeneratePasswordPageState.initial());

  Future<void> init() async {
    generatePassword();
  }

  void changeCharacterSet(CharacterSetType characterSetType) {
    if (state.characterSetType == characterSetType) {
      return;
    }

    List<PasswordLevelType> passwordLengthOptions = _getPasswordLengthOptions(characterSetType);
    PasswordLevelType passwordLengthType = state.passwordLengthType == PasswordLevelType.custom
        ? PasswordLevelType.custom
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

  void changePasswordLengthType(PasswordLevelType passwordLengthType) {
    PasswordLevelType nextPasswordLengthType = state.passwordLengthOptions.contains(passwordLengthType)
        ? passwordLengthType
        : _getDefaultPasswordLengthType(state.characterSetType);

    if (nextPasswordLengthType == PasswordLevelType.custom) {
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
    if (state.passwordLengthType == PasswordLevelType.custom) {
      return;
    }

    emit(state.copyWith(passwordLengthType: PasswordLevelType.custom));
  }

  void applyCustomPasswordLength() {
    if (state.passwordLengthType != PasswordLevelType.custom) {
      return;
    }

    if (_isCustomPasswordLengthValid(state.customPasswordLengthText) == false) {
      return;
    }

    int customPasswordLength = _clampCustomPasswordLength(state.customPasswordLengthText);
    if (state.passwordLengthType == PasswordLevelType.custom && state.passwordLength == customPasswordLength) {
      return;
    }

    emit(state.copyWith(passwordLengthType: PasswordLevelType.custom));
    generatePassword();
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePasswordBool: !state.obscurePasswordBool));
  }

  void generatePassword() {
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
        randomCharacterCount: password.randomCharacterCount,
        passwordSecurityLevel: _getPasswordSecurityLevel(entropy),
      ),
    );
  }

  PasswordLevelType _getPasswordSecurityLevel(double entropy) {
    if (entropy < 80) {
      return PasswordLevelType.unsafe;
    }

    if (entropy < 112) {
      return PasswordLevelType.weak;
    }

    if (entropy < 128) {
      return PasswordLevelType.good;
    }

    if (entropy < 256) {
      return PasswordLevelType.excellent;
    }

    return PasswordLevelType.magnificent;
  }

  int _getPasswordLength() {
    switch (state.passwordLengthType) {
      case PasswordLevelType.custom:
        return _clampCustomPasswordLength(state.customPasswordLengthText);
      case PasswordLevelType.good:
        return state.characterSetType == CharacterSetType.sip2
            ? PasswordLevelType.good.defaultLengthSip2!
            : PasswordLevelType.good.defaultLengthAscii!;
      case PasswordLevelType.excellent:
      case PasswordLevelType.magnificent:
      default:
        return state.passwordLengthType.defaultLengthAscii!;
    }
  }

  int _clampCustomPasswordLength(String text) {
    int? passwordLength = int.tryParse(text);
    if (passwordLength == null) {
      return PasswordLevelType.excellent.defaultLengthAscii!;
    }

    return passwordLength.clamp(minCustomPasswordLength, maxCustomPasswordLength);
  }

  bool _isCustomPasswordLengthValid(String text) {
    int? passwordLength = int.tryParse(text);
    if (passwordLength == null) {
      emit(state.copyWith(customPasswordLengthInvalidBool: true));
      return false;
    }

    if (passwordLength >= minCustomPasswordLength && passwordLength <= maxCustomPasswordLength) {
      emit(state.copyWith(customPasswordLengthInvalidBool: false));
      return true;
    } else {
      emit(state.copyWith(customPasswordLengthInvalidBool: true));
      return false;
    }
  }

  PasswordGenerator _getPasswordGenerator() {
    switch (state.characterSetType) {
      case CharacterSetType.ascii:
        return PasswordGenerator.ascii();
      case CharacterSetType.sip2:
        return PasswordGenerator.sip2();
    }
  }

  PasswordLevelType _getDefaultPasswordLengthType(CharacterSetType characterSetType) {
    switch (characterSetType) {
      case CharacterSetType.ascii:
        return PasswordLevelType.excellent;
      case CharacterSetType.sip2:
        return PasswordLevelType.good;
    }
  }

  List<PasswordLevelType> _getPasswordLengthOptions(CharacterSetType characterSetType) {
    switch (characterSetType) {
      case CharacterSetType.ascii:
        return _asciiPasswordLengthOptions;
      case CharacterSetType.sip2:
        return _sip2PasswordLengthOptions;
    }
  }
}
