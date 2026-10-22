import 'package:cryptography_utils/cryptography_utils.dart' show CharacterSetType;
import 'package:equatable/equatable.dart';
import 'package:snggle/bloc/pages/password_generator/password_level_type.dart';

class GeneratePasswordPageState extends Equatable {
  final CharacterSetType characterSetType;
  final PasswordLevelType calculatedPasswordLevelType;
  final PasswordLevelType selectedPasswordLevelType;
  final String customPasswordLength;
  final String password;
  final double passwordEntropy;
  final int checksumCharacterCount;
  final int randomCharacterCount;
  final bool obscurePasswordBool;
  final List<PasswordLevelType> passwordLevelTypeList;
  final bool customPasswordLengthInvalidBool;

  const GeneratePasswordPageState({
    required this.characterSetType,
    required this.calculatedPasswordLevelType,
    required this.selectedPasswordLevelType,
    required this.customPasswordLength,
    required this.password,
    required this.passwordEntropy,
    required this.checksumCharacterCount,
    required this.randomCharacterCount,
    required this.passwordLevelTypeList,
    this.obscurePasswordBool = true,
    this.customPasswordLengthInvalidBool = false,
  });

  factory GeneratePasswordPageState.initial() {
    return const GeneratePasswordPageState(
      characterSetType: CharacterSetType.ascii,
      calculatedPasswordLevelType: PasswordLevelType.excellent,
      selectedPasswordLevelType: PasswordLevelType.excellent,
      customPasswordLength: '',
      password: '',
      passwordEntropy: 0,
      checksumCharacterCount: 0,
      randomCharacterCount: 0,
      passwordLevelTypeList: <PasswordLevelType>[
        PasswordLevelType.good,
        PasswordLevelType.excellent,
        PasswordLevelType.magnificent,
        PasswordLevelType.custom,
      ],
    );
  }

  GeneratePasswordPageState copyWith({
    CharacterSetType? characterSetType,
    PasswordLevelType? calculatedPasswordLevelType,
    PasswordLevelType? selectedPasswordLevelType,
    String? customPasswordLength,
    String? password,
    double? passwordEntropy,
    int? checksumCharacterCount,
    int? randomCharacterCount,
    bool? obscurePasswordBool,
    List<PasswordLevelType>? passwordLevelTypeList,
    bool? customPasswordLengthInvalidBool,
  }) {
    return GeneratePasswordPageState(
      characterSetType: characterSetType ?? this.characterSetType,
      calculatedPasswordLevelType: calculatedPasswordLevelType ?? this.calculatedPasswordLevelType,
      selectedPasswordLevelType: selectedPasswordLevelType ?? this.selectedPasswordLevelType,
      customPasswordLength: customPasswordLength ?? this.customPasswordLength,
      password: password ?? this.password,
      passwordEntropy: passwordEntropy ?? this.passwordEntropy,
      checksumCharacterCount: checksumCharacterCount ?? this.checksumCharacterCount,
      randomCharacterCount: randomCharacterCount ?? this.randomCharacterCount,
      obscurePasswordBool: obscurePasswordBool ?? this.obscurePasswordBool,
      passwordLevelTypeList: passwordLevelTypeList ?? this.passwordLevelTypeList,
      customPasswordLengthInvalidBool: customPasswordLengthInvalidBool ?? this.customPasswordLengthInvalidBool,
    );
  }

  @override
  List<Object> get props => <Object>[
    characterSetType,
    calculatedPasswordLevelType,
    selectedPasswordLevelType,
    customPasswordLength,
    password,
    passwordEntropy,
    checksumCharacterCount,
    randomCharacterCount,
    obscurePasswordBool,
    passwordLevelTypeList,
    customPasswordLengthInvalidBool,
  ];
}
