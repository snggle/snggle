import 'package:equatable/equatable.dart';

class MnemonicFormGeneratedState extends Equatable {
  final bool finishPrerequisiteBool;
  final bool obscureTextBool;
  final bool scrolledBottomBool;
  final bool statementAcceptedBool;

  const MnemonicFormGeneratedState({
    this.finishPrerequisiteBool = true,
    this.obscureTextBool = true,
    this.scrolledBottomBool = false,
    this.statementAcceptedBool = false,
  });

  bool get finishButtonEnabledBool {
    return finishPrerequisiteBool && scrolledBottomBool && statementAcceptedBool;
  }

  MnemonicFormGeneratedState copyWith({
    bool? finishPrerequisiteBool,
    bool? obscureTextBool,
    bool? scrolledBottomBool,
    bool? statementAcceptedBool,
  }) {
    return MnemonicFormGeneratedState(
      finishPrerequisiteBool: finishPrerequisiteBool ?? this.finishPrerequisiteBool,
      obscureTextBool: obscureTextBool ?? this.obscureTextBool,
      scrolledBottomBool: scrolledBottomBool ?? this.scrolledBottomBool,
      statementAcceptedBool: statementAcceptedBool ?? this.statementAcceptedBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        finishPrerequisiteBool,
        obscureTextBool,
        scrolledBottomBool,
        statementAcceptedBool,
      ];
}
