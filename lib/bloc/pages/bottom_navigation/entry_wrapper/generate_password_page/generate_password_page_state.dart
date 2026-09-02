import 'package:cryptography_utils/cryptography_utils.dart' show CharacterSetType;
import 'package:equatable/equatable.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/password_level_type.dart';

class GeneratePasswordPageState extends Equatable {
  final CharacterSetType characterSetType;
  final PasswordLevelType passwordLengthType;
  final String customPasswordLengthText;
  final String password;
  final double passwordEntropy;
  final int passwordLength;
  final int checksumCharacterCount;
  final int randomCharacterCount;
  final bool obscurePasswordBool;
  final PasswordLevelType passwordSecurityLevel;
  final List<PasswordLevelType> passwordLengthOptions;
  final bool customPasswordLengthInvalidBool;

  const GeneratePasswordPageState({
    required this.characterSetType,
    required this.passwordLengthType,
    required this.customPasswordLengthText,
    required this.password,
    required this.passwordEntropy,
    required this.passwordLength,
    required this.checksumCharacterCount,
    required this.randomCharacterCount,
    required this.passwordSecurityLevel,
    required this.passwordLengthOptions,
    this.obscurePasswordBool = true,
    this.customPasswordLengthInvalidBool = false,
  });

  factory GeneratePasswordPageState.initial() {
    return const GeneratePasswordPageState(
      characterSetType: CharacterSetType.ascii,
      passwordLengthType: PasswordLevelType.excellent,
      customPasswordLengthText: '',
      password: '',
      passwordEntropy: 0,
      passwordLength: 0,
      checksumCharacterCount: 0,
      randomCharacterCount: 0,
      passwordSecurityLevel: PasswordLevelType.excellent,
      passwordLengthOptions: <PasswordLevelType>[
        PasswordLevelType.good,
        PasswordLevelType.excellent,
        PasswordLevelType.magnificent,
        PasswordLevelType.custom,
      ],
    );
  }

  GeneratePasswordPageState copyWith({
    CharacterSetType? characterSetType,
    PasswordLevelType? passwordLengthType,
    String? customPasswordLengthText,
    String? password,
    double? passwordEntropy,
    int? passwordLength,
    int? checksumCharacterCount,
    int? randomCharacterCount,
    bool? obscurePasswordBool,
    PasswordLevelType? passwordSecurityLevel,
    List<PasswordLevelType>? passwordLengthOptions,
    bool? customPasswordLengthInvalidBool,
  }) {
    return GeneratePasswordPageState(
      characterSetType: characterSetType ?? this.characterSetType,
      passwordLengthType: passwordLengthType ?? this.passwordLengthType,
      customPasswordLengthText: customPasswordLengthText ?? this.customPasswordLengthText,
      password: password ?? this.password,
      passwordEntropy: passwordEntropy ?? this.passwordEntropy,
      passwordLength: passwordLength ?? this.passwordLength,
      checksumCharacterCount: checksumCharacterCount ?? this.checksumCharacterCount,
      randomCharacterCount: randomCharacterCount ?? this.randomCharacterCount,
      obscurePasswordBool: obscurePasswordBool ?? this.obscurePasswordBool,
      passwordSecurityLevel: passwordSecurityLevel ?? this.passwordSecurityLevel,
      passwordLengthOptions: passwordLengthOptions ?? this.passwordLengthOptions,
      customPasswordLengthInvalidBool: customPasswordLengthInvalidBool ?? this.customPasswordLengthInvalidBool,
    );
  }

  @override
  List<Object> get props => <Object>[
    characterSetType,
    passwordLengthType,
    customPasswordLengthText,
    password,
    passwordEntropy,
    passwordLength,
    checksumCharacterCount,
    randomCharacterCount,
    obscurePasswordBool,
    passwordSecurityLevel,
    passwordLengthOptions,
    customPasswordLengthInvalidBool,
  ];
}
