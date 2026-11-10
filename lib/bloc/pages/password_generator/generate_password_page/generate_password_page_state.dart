import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:snggle/bloc/pages/password_generator/password_character_set_mode.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';

class GeneratePasswordPageState extends Equatable {
  static const int maximumCustomPasswordLength = 256;
  static const int minimumCustomPasswordLength = 4;

  final int checksumCharacterCount;
  final String customPasswordLength;
  final String password;
  final double passwordEntropy;
  final int randomCharacterCount;
  final PasswordCharactersConfig advancedPasswordCharactersConfig;
  final PasswordLevelType calculatedPasswordLevelType;
  final PasswordCharacterSetMode passwordCharacterSetMode;
  final PasswordLevelType selectedPasswordLevelType;
  final bool obscurePasswordBool;

  const GeneratePasswordPageState({
    required this.checksumCharacterCount,
    required this.customPasswordLength,
    required this.password,
    required this.passwordEntropy,
    required this.randomCharacterCount,
    required this.advancedPasswordCharactersConfig,
    required this.calculatedPasswordLevelType,
    required this.passwordCharacterSetMode,
    required this.selectedPasswordLevelType,
    this.obscurePasswordBool = true,
  });

  factory GeneratePasswordPageState.initial({
    required PasswordCharacterSetMode passwordCharacterSetMode,
    bool obscurePasswordBool = true,
  }) {
    PasswordLevelType initialPasswordLevelType = PasswordLevelType.excellent;
    return GeneratePasswordPageState(
      passwordCharacterSetMode: passwordCharacterSetMode,
      advancedPasswordCharactersConfig: PasswordCharactersConfig(),
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

  GeneratePasswordPageState copyWith({
    PasswordCharacterSetMode? passwordCharacterSetMode,
    PasswordCharactersConfig? advancedPasswordCharactersConfig,
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
      passwordCharacterSetMode: passwordCharacterSetMode ?? this.passwordCharacterSetMode,
      advancedPasswordCharactersConfig: advancedPasswordCharactersConfig ?? this.advancedPasswordCharactersConfig,
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

  int? calculatePasswordLength(PasswordLevelType passwordLevelType) {
    int? target = passwordLevelType.entropyTarget;
    return target == null ? null : passwordGeneratorConfig.minimumLengthForEntropy(target);
  }

  bool get customPasswordLengthInvalidBool {
    int? length = int.tryParse(customPasswordLength);
    return length == null || length < minimumCustomPasswordLength || length > maximumCustomPasswordLength;
  }

  bool get generationAvailableBool => resolvedPasswordLength != null;

  PasswordGeneratorConfig get passwordGeneratorConfig {
    switch (passwordCharacterSetMode) {
      case PasswordCharacterSetMode.ascii:
        return PasswordGeneratorConfig.ascii();
      case PasswordCharacterSetMode.sip2:
        return PasswordGeneratorConfig.sip2();
      case PasswordCharacterSetMode.advanced:
        return PasswordGeneratorConfig.advanced(advancedPasswordCharactersConfig);
    }
  }

  bool get passwordReadyBool => generationAvailableBool && password.isNotEmpty && password.length == resolvedPasswordLength;

  int? get resolvedPasswordLength => selectedPasswordLevelType == PasswordLevelType.custom
      ? (customPasswordLengthInvalidBool ? null : int.parse(customPasswordLength))
      : calculatePasswordLength(selectedPasswordLevelType);

  List<PasswordLevelType> get selectablePasswordLevels => const <PasswordLevelType>[
    PasswordLevelType.good,
    PasswordLevelType.excellent,
    PasswordLevelType.magnificent,
    PasswordLevelType.custom,
  ];

  @override
  List<Object?> get props => <Object?>[
    passwordCharacterSetMode,
    advancedPasswordCharactersConfig,
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
