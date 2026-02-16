import 'package:equatable/equatable.dart';

abstract class AAppEnterPinPageState extends Equatable {
  static const int maxInvalidAttempts = 3;
  final List<int> pinNumbers;
  final int invalidAttemptsCount;

  const AAppEnterPinPageState({
    required this.pinNumbers,
    this.invalidAttemptsCount = 0,
  });

  int get attemptsLeft => maxInvalidAttempts - invalidAttemptsCount;

  @override
  List<Object> get props => <Object>[pinNumbers, invalidAttemptsCount];
}
