import 'dart:async';

import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';

class GeneratePasswordPageCubit extends Cubit<GeneratePasswordPageState> {
  static const int minCustomPasswordLength = GeneratePasswordPageState.minCustomPasswordLength;
  static const int maxCustomPasswordLength = GeneratePasswordPageState.maxCustomPasswordLength;

  GeneratePasswordPageCubit({
    PasswordCharacterSetMode characterSetMode = PasswordCharacterSetMode.ascii,
    bool obscurePasswordBool = true,
  }) : super(GeneratePasswordPageState.initial(characterSetMode: characterSetMode, obscurePasswordBool: obscurePasswordBool));

  Future<void> init() async {
    generatePassword();
  }

  void changeCharacterSetMode(PasswordCharacterSetMode characterSetMode) {
    if (state.characterSetMode == characterSetMode) {
      return;
    }

    _generatePassword(state.copyWith(characterSetMode: characterSetMode));
  }

  void toggleLowercase() {
    _updateAdvancedSettings(lowercase: state.advancedCharacterSettings?.lowercase == false);
  }

  void toggleUppercase() {
    _updateAdvancedSettings(uppercase: state.advancedCharacterSettings?.uppercase == false);
  }

  void toggleNumbers() {
    _updateAdvancedSettings(numbers: state.advancedCharacterSettings?.numbers == false);
  }

  void toggleSpecial() {
    _updateAdvancedSettings(special: state.advancedCharacterSettings?.special == false);
  }

  void toggleRemoveAmbiguous() {
    _updateAdvancedSettings(removeAmbiguous: state.removeAmbiguousBool == false);
  }

  void _updateAdvancedSettings({bool? lowercase, bool? uppercase, bool? numbers, bool? special, bool? removeAmbiguous}) {
    PasswordCharactersConfig? current = state.advancedCharacterSettings;
    bool nextLowercase = lowercase ?? current?.lowercase ?? false;
    bool nextUppercase = uppercase ?? current?.uppercase ?? false;
    bool nextNumbers = numbers ?? current?.numbers ?? false;
    bool nextSpecial = special ?? current?.special ?? false;
    bool nextRemoveAmbiguous = removeAmbiguous ?? state.removeAmbiguousBool;
    bool emptyBool = nextLowercase == false && nextUppercase == false && nextNumbers == false && nextSpecial == false;

    PasswordCharactersConfig? settings = emptyBool
        ? null
        : PasswordCharactersConfig(
            lowercase: nextLowercase,
            uppercase: nextUppercase,
            numbers: nextNumbers,
            special: nextSpecial,
            removeAmbiguous: nextRemoveAmbiguous,
          );
    GeneratePasswordPageState nextState = state.copyWith(
      advancedCharacterSettings: settings,
      clearAdvancedCharacterSettingsBool: emptyBool,
      removeAmbiguousWhenInvalidBool: emptyBool && nextRemoveAmbiguous,
    );

    if (state.characterSetMode == PasswordCharacterSetMode.advanced) {
      _generatePassword(nextState);
    } else {
      emit(nextState);
    }
  }

  void changePasswordLevelType(PasswordLevelType passwordLevelType) {
    if (state.passwordLevelTypeList.contains(passwordLevelType) == false || state.selectedPasswordLevelType == passwordLevelType) {
      return;
    }

    _generatePassword(state.copyWith(selectedPasswordLevelType: passwordLevelType));
  }

  void updateCustomPasswordLengthText(String text) {
    if (state.customPasswordLength == text) {
      return;
    }

    GeneratePasswordPageState nextState = state.copyWith(customPasswordLength: text);
    if (state.selectedPasswordLevelType == PasswordLevelType.custom) {
      _generatePassword(nextState);
    } else {
      emit(nextState);
    }
  }

  void selectCustomPasswordLevel() {
    changePasswordLevelType(PasswordLevelType.custom);
  }

  void applyCustomPasswordLevel() {
    if (state.selectedPasswordLevelType == PasswordLevelType.custom && state.passwordReadyBool == false) {
      generatePassword();
    }
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePasswordBool: !state.obscurePasswordBool));
  }

  void generatePassword() {
    _generatePassword(state);
  }

  void _generatePassword(GeneratePasswordPageState nextState) {
    PasswordGeneratorConfig? config = nextState.effectiveConfig;
    int? length = nextState.resolvedPasswordLength;
    if (config == null || length == null) {
      emit(
        nextState.copyWith(
          password: '',
          passwordEntropy: 0,
          checksumCharacterCount: 0,
          randomCharacterCount: 0,
          calculatedPasswordLevelType: PasswordLevelType.unsafe,
        ),
      );
      return;
    }

    Password password = PasswordGenerator(config).generate(length);
    emit(
      nextState.copyWith(
        password: password.password,
        passwordEntropy: password.entropy,
        checksumCharacterCount: password.checksumCharacterCount,
        randomCharacterCount: password.randomCharacterCount,
        calculatedPasswordLevelType: _calculatePasswordLevel(password.entropy),
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
}
