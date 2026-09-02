import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/password_generator/generate_password_page/generate_password_page_state.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';

class GeneratePasswordPageCubit extends Cubit<GeneratePasswordPageState> {
  static const int maximumCustomPasswordLength = GeneratePasswordPageState.maximumCustomPasswordLength;
  static const int minimumCustomPasswordLength = GeneratePasswordPageState.minimumCustomPasswordLength;

  GeneratePasswordPageCubit({
    PasswordCharacterSetMode passwordCharacterSetMode = PasswordCharacterSetMode.ascii,
    bool obscurePasswordBool = true,
  }) : super(GeneratePasswordPageState.initial(passwordCharacterSetMode: passwordCharacterSetMode, obscurePasswordBool: obscurePasswordBool));

  void applyCustomPasswordLevel() {
    bool regenerationRequiredBool = state.selectedPasswordLevelType == PasswordLevelType.custom && state.passwordUpdatedBool == false;
    if (regenerationRequiredBool) {
      generatePassword();
    }
  }

  void changeCharacterSetMode(PasswordCharacterSetMode passwordCharacterSetMode) {
    bool matchingCharacterSetBool = state.passwordCharacterSetMode == passwordCharacterSetMode;
    if (matchingCharacterSetBool) {
      return;
    }

    _generatePassword(state.copyWith(passwordCharacterSetMode: passwordCharacterSetMode));
  }

  void changePasswordLevelType(PasswordLevelType passwordLevelType) {
    bool selectionUnavailableBool =
        state.selectablePasswordLevels.contains(passwordLevelType) == false || state.selectedPasswordLevelType == passwordLevelType;
    if (selectionUnavailableBool) {
      return;
    }

    _generatePassword(state.copyWith(selectedPasswordLevelType: passwordLevelType));
  }

  void generatePassword() {
    _generatePassword(state);
  }

  void init() {
    generatePassword();
  }

  void selectCustomPasswordLevel() {
    changePasswordLevelType(PasswordLevelType.custom);
  }

  bool shouldWarnPassword() {
    return state.calculatedPasswordLevelType == PasswordLevelType.unsafe || state.calculatedPasswordLevelType == PasswordLevelType.weak;
  }

  void toggleLowercase() {
    _updateAdvancedSettings(lowercaseBool: state.advancedPasswordCharactersConfig.lowercase == false);
  }

  void toggleNumbers() {
    _updateAdvancedSettings(numbersBool: state.advancedPasswordCharactersConfig.numbers == false);
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePasswordBool: state.obscurePasswordBool == false));
  }

  void toggleSpecial() {
    _updateAdvancedSettings(specialBool: state.advancedPasswordCharactersConfig.special == false);
  }

  void toggleUppercase() {
    _updateAdvancedSettings(uppercaseBool: state.advancedPasswordCharactersConfig.uppercase == false);
  }

  void updateCustomLength(String customPasswordLength) {
    bool matchingLengthBool = state.customPasswordLength == customPasswordLength;
    if (matchingLengthBool) {
      return;
    }

    GeneratePasswordPageState generatePasswordPageState = state.copyWith(customPasswordLength: customPasswordLength);
    bool customLevelSelectedBool = state.selectedPasswordLevelType == PasswordLevelType.custom;
    if (customLevelSelectedBool) {
      _generatePassword(generatePasswordPageState);
    } else {
      emit(generatePasswordPageState);
    }
  }

  PasswordLevelType _calculatePasswordLevel(double entropy) {
    bool unsafeLevelBool = entropy < 80;
    if (unsafeLevelBool) {
      return PasswordLevelType.unsafe;
    }

    bool weakLevelBool = entropy < 112;
    if (weakLevelBool) {
      return PasswordLevelType.weak;
    }

    bool goodLevelBool = entropy < 128;
    if (goodLevelBool) {
      return PasswordLevelType.good;
    }

    bool excellentLevelBool = entropy < 256;
    if (excellentLevelBool) {
      return PasswordLevelType.excellent;
    }

    return PasswordLevelType.magnificent;
  }

  void _generatePassword(GeneratePasswordPageState generatePasswordPageState) {
    PasswordGeneratorConfig passwordGeneratorConfig = generatePasswordPageState.passwordGeneratorConfig;
    int? length = generatePasswordPageState.setPasswordLength;
    bool invalidLengthBool = length == null;
    if (invalidLengthBool) {
      emit(
        generatePasswordPageState.copyWith(
          password: '',
          passwordEntropy: 0,
          checksumCharacterCount: 0,
          randomCharacterCount: 0,
          calculatedPasswordLevelType: PasswordLevelType.unsafe,
        ),
      );
      return;
    }

    Password password = PasswordGenerator(passwordGeneratorConfig).generate(length);
    emit(
      generatePasswordPageState.copyWith(
        password: password.password,
        passwordEntropy: password.entropy,
        checksumCharacterCount: password.checksumCharacterCount,
        randomCharacterCount: password.randomCharacterCount,
        calculatedPasswordLevelType: _calculatePasswordLevel(password.entropy),
      ),
    );
  }

  void _updateAdvancedSettings({bool? lowercaseBool, bool? uppercaseBool, bool? numbersBool, bool? specialBool}) {
    PasswordCharactersConfig currentPasswordCharactersConfig = state.advancedPasswordCharactersConfig;
    bool nextLowercaseBool = lowercaseBool ?? currentPasswordCharactersConfig.lowercase;
    bool nextUppercaseBool = uppercaseBool ?? currentPasswordCharactersConfig.uppercase;
    bool nextNumbersBool = numbersBool ?? currentPasswordCharactersConfig.numbers;
    bool nextSpecialBool = specialBool ?? currentPasswordCharactersConfig.special;
    bool emptyCharacterSetBool = nextLowercaseBool == false && nextUppercaseBool == false && nextNumbersBool == false && nextSpecialBool == false;
    if (emptyCharacterSetBool) {
      return;
    }

    PasswordCharactersConfig passwordCharactersConfig = PasswordCharactersConfig(
      lowercase: nextLowercaseBool,
      uppercase: nextUppercaseBool,
      numbers: nextNumbersBool,
      special: nextSpecialBool,
    );
    GeneratePasswordPageState generatePasswordPageState = state.copyWith(advancedPasswordCharactersConfig: passwordCharactersConfig);

    bool advancedModeBool = state.passwordCharacterSetMode == PasswordCharacterSetMode.advanced;
    if (advancedModeBool) {
      _generatePassword(generatePasswordPageState);
    } else {
      emit(generatePasswordPageState);
    }
  }
}
