import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart';

class PinpadKeyboardCubit extends Cubit<PinpadKeyboardState> {
  PinpadKeyboardCubit({PinpadKeyboardState initPinpadKeyboardState = PinpadKeyboardState.initPinpadKeyboardState})
    : super(initPinpadKeyboardState);

  void toggleShuffling() {
    if (state.shuffleEnabledBool == false) {
      shuffle();
    } else {
      emit(PinpadKeyboardState.initPinpadKeyboardState);
    }
  }

  void shuffle() {
    List<int> visibleNumbersList = List<int>.from(PinpadKeyboardState.initPinpadKeyboardState.visibleNumbersList)..shuffle();

    emit(
      PinpadKeyboardState(
        shuffleEnabledBool: true,
        visibleNumbersList: List<int>.unmodifiable(visibleNumbersList),
      ),
    );
  }
}
