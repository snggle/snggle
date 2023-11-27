import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart';

class PinpadKeyboardCubit extends Cubit<PinpadKeyboardState> {
  static const List<int> _pinpadNumbers = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  PinpadKeyboardCubit() : super(const PinpadKeyboardState(shuffleEnabledBool: false, visibleNumbers: _pinpadNumbers));

  void toggleShuffling() {
    if (state.shuffleEnabledBool == false) {
      shuffle();
    } else {
      emit(PinpadKeyboardState(
        shuffleEnabledBool: false,
        visibleNumbers: List<int>.from(_pinpadNumbers),
      ));
    }
  }

  void shuffle() {
    List<int> visibleNumbers = List<int>.from(_pinpadNumbers)..shuffle();
    emit(PinpadKeyboardState(shuffleEnabledBool: true, visibleNumbers: visibleNumbers));
  }
}
