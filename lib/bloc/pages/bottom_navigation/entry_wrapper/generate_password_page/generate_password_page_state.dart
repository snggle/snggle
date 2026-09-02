import 'package:equatable/equatable.dart';

class GeneratePasswordPageState extends Equatable {
  final bool obscurePasswordBool;

  const GeneratePasswordPageState({
    this.obscurePasswordBool = true,
  });

  GeneratePasswordPageState copyWith({
    bool? obscurePasswordBool,
  }) {
    return GeneratePasswordPageState(
      obscurePasswordBool: obscurePasswordBool ?? this.obscurePasswordBool,
    );
  }

  @override
  List<Object> get props => <Object>[obscurePasswordBool];
}
