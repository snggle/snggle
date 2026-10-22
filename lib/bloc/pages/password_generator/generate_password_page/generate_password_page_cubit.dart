import 'dart:async';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';

class GeneratePasswordPageCubit extends Cubit<GeneratePasswordPageState> {
  static const int minCustomPasswordLength = 4;
  static const int maxCustomPasswordLength = 256;

  static const List<PasswordLevelType> _asciiPasswordLevelOptions = <PasswordLevelType>[
    PasswordLevelType.good,
    PasswordLevelType.excellent,
    PasswordLevelType.magnificent,
    PasswordLevelType.custom,
  ];
  static const List<PasswordLevelType> _sip2PasswordLevelOptions = <PasswordLevelType>[
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

    List<PasswordLevelType> passwordLevelOptions = _getPasswordLevelOptions(characterSetType);
    PasswordLevelType passwordLevelType =
        (state.selectedPasswordLevelType == PasswordLevelType.custom && state.customPasswordLengthInvalidBool == false)
        ? PasswordLevelType.custom
        : _getDefaultPasswordLevelTypeOptions(characterSetType);

    emit(
      state.copyWith(
        characterSetType: characterSetType,
        selectedPasswordLevelType: passwordLevelType,
        passwordLevelTypeList: passwordLevelOptions,
      ),
    );

    generatePassword();
  }

  void changePasswordLevelType(PasswordLevelType passwordLevelType) {
    PasswordLevelType nextPasswordLevelTypeType = state.passwordLevelTypeList.contains(passwordLevelType)
        ? passwordLevelType
        : _getDefaultPasswordLevelTypeOptions(state.characterSetType);

    if (nextPasswordLevelTypeType == PasswordLevelType.custom) {
      selectCustomPasswordLevel();
      return;
    }

    if (state.selectedPasswordLevelType == nextPasswordLevelTypeType) {
      return;
    }

    emit(state.copyWith(selectedPasswordLevelType: nextPasswordLevelTypeType));
    generatePassword();
  }

  void updateCustomPasswordLengthText(String text) {
    if (state.customPasswordLength == text) {
      return;
    }

    emit(state.copyWith(customPasswordLength: text));
  }

  void selectCustomPasswordLevel() {
    if (state.selectedPasswordLevelType == PasswordLevelType.custom) {
      return;
    }

    emit(state.copyWith(selectedPasswordLevelType: PasswordLevelType.custom));
  }

  void applyCustomPasswordLevel() {
    if (state.selectedPasswordLevelType != PasswordLevelType.custom) {
      return;
    }

    if (_isCustomPasswordLengthValid(state.customPasswordLength) == false) {
      return;
    }

    int customPasswordLevelLength = _clampCustomPasswordLength(state.customPasswordLength);
    if (state.selectedPasswordLevelType == PasswordLevelType.custom && state.password.length == customPasswordLevelLength) {
      return;
    }

    emit(state.copyWith(selectedPasswordLevelType: PasswordLevelType.custom));
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
        checksumCharacterCount: password.checksumCharacterCount,
        randomCharacterCount: password.randomCharacterCount,
        calculatedPasswordLevelType: _calculatePasswordLevel(entropy),
      ),
    );
  }

  PasswordLevelType _calculatePasswordLevel(double entropy) {
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
    switch (state.selectedPasswordLevelType) {
      case PasswordLevelType.custom:
        return _clampCustomPasswordLength(state.customPasswordLength);
      case PasswordLevelType.good:
        return state.characterSetType == CharacterSetType.sip2
            ? PasswordLevelType.good.defaultLengthSip2!
            : PasswordLevelType.good.defaultLengthAscii!;
      case PasswordLevelType.excellent:
      case PasswordLevelType.magnificent:
      default:
        return state.selectedPasswordLevelType.defaultLengthAscii!;
    }
  }

  int _clampCustomPasswordLength(String text) {
    int? passwordLevel = int.tryParse(text);
    if (passwordLevel == null) {
      return PasswordLevelType.excellent.defaultLengthAscii!;
    }

    if (state.selectedPasswordLevelType == PasswordLevelType.custom && state.customPasswordLengthInvalidBool) {
      emit(state.copyWith(selectedPasswordLevelType: _getDefaultPasswordLevelTypeOptions(state.characterSetType)));
    }

    return passwordLevel.clamp(minCustomPasswordLength, maxCustomPasswordLength);
  }

  bool _isCustomPasswordLengthValid(String text) {
    int? passwordLevel = int.tryParse(text);
    if (passwordLevel == null) {
      emit(state.copyWith(customPasswordLengthInvalidBool: true));
      return false;
    }

    if (passwordLevel >= minCustomPasswordLength && passwordLevel <= maxCustomPasswordLength) {
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

  PasswordLevelType _getDefaultPasswordLevelTypeOptions(CharacterSetType characterSetType) {
    switch (characterSetType) {
      case CharacterSetType.ascii:
        return PasswordLevelType.excellent;
      case CharacterSetType.sip2:
        return PasswordLevelType.good;
    }
  }

  List<PasswordLevelType> _getPasswordLevelOptions(CharacterSetType characterSetType) {
    switch (characterSetType) {
      case CharacterSetType.ascii:
        return _asciiPasswordLevelOptions;
      case CharacterSetType.sip2:
        return _sip2PasswordLevelOptions;
    }
  }
}
