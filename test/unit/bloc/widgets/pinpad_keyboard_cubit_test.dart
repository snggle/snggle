import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_cubit.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart';

void main() {
  List<int> sortedKeyboardNumbers = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  PinpadKeyboardCubit actualPinpadKeyboardCubit = PinpadKeyboardCubit();

  group('Tests of [PinpadKeyboardCubit]', () {
    test('Should [return PinpadKeyboardState] with sorted numbers as initial state', () {
      // Assert
      PinpadKeyboardState expectedPinpadKeyboardState = PinpadKeyboardState(
        shuffleEnabledBool: false,
        visibleNumbers: sortedKeyboardNumbers,
      );

      expect(actualPinpadKeyboardCubit.state, expectedPinpadKeyboardState);
    });

    test('Should [return PinpadKeyboardState] with shuffled numbers', () {
      // Act
      actualPinpadKeyboardCubit.toggleShuffling();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, true);
      expect(actualPinpadKeyboardCubit.state.visibleNumbers, isNot(sortedKeyboardNumbers));
    });

    test('Should [return PinpadKeyboardState] with unshuffled numbers (sorted again)', () {
      // Act
      actualPinpadKeyboardCubit.toggleShuffling();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, false);
      expect(actualPinpadKeyboardCubit.state.visibleNumbers, sortedKeyboardNumbers);
    });

    test('Should [return PinpadKeyboardState] with shuffled numbers (different arrangement)', () {
      // Act
      actualPinpadKeyboardCubit.shuffle();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, true);
      expect(actualPinpadKeyboardCubit.state.visibleNumbers, isNot(sortedKeyboardNumbers));

      // ******************************************************************************************

      // Act
      List<int> actualPreviousNumbers = actualPinpadKeyboardCubit.state.visibleNumbers;
      actualPinpadKeyboardCubit.shuffle();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, true);
      expect(actualPinpadKeyboardCubit.state.visibleNumbers, isNot(actualPreviousNumbers));
      expect(actualPinpadKeyboardCubit.state.visibleNumbers, isNot(sortedKeyboardNumbers));

      // ******************************************************************************************

      // Act
      actualPreviousNumbers = actualPinpadKeyboardCubit.state.visibleNumbers;
      actualPinpadKeyboardCubit.shuffle();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, true);
      expect(actualPinpadKeyboardCubit.state.visibleNumbers, isNot(actualPreviousNumbers));
      expect(actualPinpadKeyboardCubit.state.visibleNumbers, isNot(sortedKeyboardNumbers));
    });
  });
}
