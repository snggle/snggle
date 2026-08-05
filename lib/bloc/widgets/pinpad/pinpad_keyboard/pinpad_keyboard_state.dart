import 'package:equatable/equatable.dart';

class PinpadKeyboardState extends Equatable {
  static const PinpadKeyboardState initPinpadKeyboardState = PinpadKeyboardState(
    shuffleEnabledBool: false,
    visibleNumbersList: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  );

  final bool shuffleEnabledBool;
  final List<int> visibleNumbersList;

  const PinpadKeyboardState({
    required this.shuffleEnabledBool,
    required this.visibleNumbersList,
  });

  @override
  List<Object> get props => <Object>[shuffleEnabledBool, visibleNumbersList];
}
