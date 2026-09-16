import 'package:equatable/equatable.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/generate_password_page/password_security_level.dart';

class GeneratePasswordPageState extends Equatable {
  final bool obscurePasswordBool;
  final PasswordSecurityLevel passwordSecurityLevel;

  const GeneratePasswordPageState({
    required this.passwordSecurityLevel,
    this.obscurePasswordBool = true,
  });

  GeneratePasswordPageState copyWith({
    bool? obscurePasswordBool,
    PasswordSecurityLevel? passwordSecurityLevel,
  }) {
    return GeneratePasswordPageState(
      obscurePasswordBool: obscurePasswordBool ?? this.obscurePasswordBool,
      passwordSecurityLevel: passwordSecurityLevel ?? this.passwordSecurityLevel,
    );
  }

  @override
  List<Object> get props => <Object>[obscurePasswordBool, passwordSecurityLevel];
}
