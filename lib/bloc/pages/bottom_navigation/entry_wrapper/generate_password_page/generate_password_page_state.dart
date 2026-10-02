import 'package:cryptography_utils/cryptography_utils.dart' show CharacterSetType;
import 'package:equatable/equatable.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/password_length_type.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/generate_password_page/password_security_level.dart';

class GeneratePasswordPageState extends Equatable {
  final CharacterSetType characterSetType;
  final PasswordLengthType passwordLengthType;
  final String customPasswordLengthText;
  final String password;
  final double passwordEntropy;
  final int passwordLength;
  final int checksumCharacterCount;
  final int randomCharacterCount;
  final bool obscurePasswordBool;
  final PasswordSecurityLevel passwordSecurityLevel;
  final List<PasswordLengthType> passwordLengthOptions;

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
  });

  factory GeneratePasswordPageState.initial({required bool obscurePasswordBool}) {
    return GeneratePasswordPageState(
      characterSetType: CharacterSetType.ascii,
      passwordLengthType: PasswordLengthType.excellent,
      customPasswordLengthText: '',
      password: '',
      passwordEntropy: 0,
      passwordLength: 0,
      checksumCharacterCount: 0,
      randomCharacterCount: 0,
      passwordSecurityLevel: PasswordSecurityLevel.excellent,
      passwordLengthOptions: const <PasswordLengthType>[
        PasswordLengthType.good,
        PasswordLengthType.excellent,
        PasswordLengthType.superb,
        PasswordLengthType.custom,
      ],
      obscurePasswordBool: obscurePasswordBool,
    );
  }

  GeneratePasswordPageState copyWith({
    CharacterSetType? characterSetType,
    PasswordLengthType? passwordLengthType,
    String? customPasswordLengthText,
    String? password,
    double? passwordEntropy,
    int? passwordLength,
    int? checksumCharacterCount,
    int? randomCharacterCount,
    bool? obscurePasswordBool,
    PasswordSecurityLevel? passwordSecurityLevel,
    List<PasswordLengthType>? passwordLengthOptions,
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
  ];
}
