import 'package:equatable/equatable.dart';

class KeyboardState extends Equatable {
  final bool shufflingEnabledBool;
  final List<String> alphabet;
  final List<String> enabledLetters;
  final List<String> hints;

  const KeyboardState({
    required this.shufflingEnabledBool,
    required this.alphabet,
    required this.enabledLetters,
    required this.hints,
  });

  @override
  List<Object?> get props => <Object?>[shufflingEnabledBool, alphabet, enabledLetters, hints];
}
