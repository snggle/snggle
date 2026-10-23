import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';

class GeneratePasswordPageState extends Equatable {
  static const int minCustomPasswordLength = 4;
  static const int maxCustomPasswordLength = 256;

  final PasswordCharacterSetMode characterSetMode;

  /// Null represents all categories being disabled. The library deliberately
  /// rejects that incomplete selection, so it must never reach the generator.
  final PasswordCharactersConfig? advancedCharacterSettings;

  /// Preserves the filter only while [advancedCharacterSettings] is null.
  final bool removeAmbiguousWhenInvalidBool;
  final PasswordLevelType calculatedPasswordLevelType;
  final PasswordLevelType selectedPasswordLevelType;
  final String customPasswordLength;
  final String password;
  final double passwordEntropy;
  final int checksumCharacterCount;
  final int randomCharacterCount;
  final bool obscurePasswordBool;

  const GeneratePasswordPageState({
    required this.characterSetMode,
    required this.advancedCharacterSettings,
    required this.calculatedPasswordLevelType,
    required this.selectedPasswordLevelType,
    required this.customPasswordLength,
    required this.password,
    required this.passwordEntropy,
    required this.checksumCharacterCount,
    required this.randomCharacterCount,
    this.obscurePasswordBool = true,
    this.removeAmbiguousWhenInvalidBool = false,
  });

  factory GeneratePasswordPageState.initial({
    PasswordCharacterSetMode characterSetMode = PasswordCharacterSetMode.ascii,
    bool obscurePasswordBool = true,
  }) {
    PasswordLevelType initialPasswordLevelType = characterSetMode == PasswordCharacterSetMode.sip2
        ? PasswordLevelType.good
        : PasswordLevelType.excellent;
    return GeneratePasswordPageState(
      characterSetMode: characterSetMode,
      advancedCharacterSettings: PasswordCharactersConfig(),
      calculatedPasswordLevelType: initialPasswordLevelType,
      selectedPasswordLevelType: initialPasswordLevelType,
      customPasswordLength: '',
      password: '',
      passwordEntropy: 0,
      checksumCharacterCount: 0,
      randomCharacterCount: 0,
      obscurePasswordBool: obscurePasswordBool,
    );
  }

  List<PasswordLevelType> get passwordLevelTypeList => const <PasswordLevelType>[
    PasswordLevelType.good,
    PasswordLevelType.excellent,
    PasswordLevelType.magnificent,
    PasswordLevelType.custom,
  ];

  bool get removeAmbiguousBool => advancedCharacterSettings?.removeAmbiguous ?? removeAmbiguousWhenInvalidBool;

  bool get characterSettingsInvalidBool => characterSetMode == PasswordCharacterSetMode.advanced && advancedCharacterSettings == null;

  bool get customPasswordLengthInvalidBool {
    int? length = int.tryParse(customPasswordLength);
    return length == null || length < minCustomPasswordLength || length > maxCustomPasswordLength;
  }

  PasswordGeneratorConfig? get effectiveConfig {
    switch (characterSetMode) {
      case PasswordCharacterSetMode.ascii:
        return PasswordGeneratorConfig.ascii();
      case PasswordCharacterSetMode.sip2:
        return PasswordGeneratorConfig.sip2();
      case PasswordCharacterSetMode.advanced:
        PasswordCharactersConfig? settings = advancedCharacterSettings;
        return settings == null ? null : PasswordGeneratorConfig.advanced(settings);
    }
  }

  int? passwordLengthForLevel(PasswordLevelType level) {
    int? target = level.entropyTarget;
    return target == null ? null : effectiveConfig?.minLengthForEntropy(target);
  }

  int? get resolvedPasswordLength => selectedPasswordLevelType == PasswordLevelType.custom
      ? (customPasswordLengthInvalidBool ? null : int.parse(customPasswordLength))
      : passwordLengthForLevel(selectedPasswordLevelType);

  bool get canGeneratePasswordBool => effectiveConfig != null && resolvedPasswordLength != null;

  bool get passwordReadyBool => canGeneratePasswordBool && password.isNotEmpty && password.length == resolvedPasswordLength;

  GeneratePasswordPageState copyWith({
    PasswordCharacterSetMode? characterSetMode,
    PasswordCharactersConfig? advancedCharacterSettings,
    bool clearAdvancedCharacterSettingsBool = false,
    bool? removeAmbiguousWhenInvalidBool,
    PasswordLevelType? calculatedPasswordLevelType,
    PasswordLevelType? selectedPasswordLevelType,
    String? customPasswordLength,
    String? password,
    double? passwordEntropy,
    int? checksumCharacterCount,
    int? randomCharacterCount,
    bool? obscurePasswordBool,
  }) {
    return GeneratePasswordPageState(
      characterSetMode: characterSetMode ?? this.characterSetMode,
      advancedCharacterSettings: clearAdvancedCharacterSettingsBool ? null : (advancedCharacterSettings ?? this.advancedCharacterSettings),
      removeAmbiguousWhenInvalidBool: removeAmbiguousWhenInvalidBool ?? this.removeAmbiguousWhenInvalidBool,
      calculatedPasswordLevelType: calculatedPasswordLevelType ?? this.calculatedPasswordLevelType,
      selectedPasswordLevelType: selectedPasswordLevelType ?? this.selectedPasswordLevelType,
      customPasswordLength: customPasswordLength ?? this.customPasswordLength,
      password: password ?? this.password,
      passwordEntropy: passwordEntropy ?? this.passwordEntropy,
      checksumCharacterCount: checksumCharacterCount ?? this.checksumCharacterCount,
      randomCharacterCount: randomCharacterCount ?? this.randomCharacterCount,
      obscurePasswordBool: obscurePasswordBool ?? this.obscurePasswordBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    characterSetMode,
    advancedCharacterSettings,
    removeAmbiguousWhenInvalidBool,
    calculatedPasswordLevelType,
    selectedPasswordLevelType,
    customPasswordLength,
    password,
    passwordEntropy,
    checksumCharacterCount,
    randomCharacterCount,
    obscurePasswordBool,
  ];
}
