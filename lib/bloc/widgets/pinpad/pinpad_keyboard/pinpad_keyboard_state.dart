import 'package:equatable/equatable.dart';

class PinpadKeyboardState extends Equatable {
  final bool shuffleEnabledBool;
  final List<int> visibleNumbers;

  const PinpadKeyboardState({
    required this.shuffleEnabledBool,
    required this.visibleNumbers,
  });

  @override
  List<Object> get props => <Object>[shuffleEnabledBool, visibleNumbers];
}
