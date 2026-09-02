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
        visibleNumbersList: sortedKeyboardNumbers,
      );

      expect(actualPinpadKeyboardCubit.state, expectedPinpadKeyboardState);
    });

    test('Should use provided initial keyboard state', () async {
      // Arrange
      const PinpadKeyboardState expectedPinpadKeyboardState =
      PinpadKeyboardState(
        shuffleEnabledBool: true,
        visibleNumbersList: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0],
      );
      PinpadKeyboardCubit pinpadKeyboardCubit = PinpadKeyboardCubit(
        initPinpadKeyboardState: expectedPinpadKeyboardState,
      );

      // Assert
      expect(pinpadKeyboardCubit.state, expectedPinpadKeyboardState);

      await pinpadKeyboardCubit.close();
    });

    test('Should [return PinpadKeyboardState] with shuffled numbers', () {
      // Act
      actualPinpadKeyboardCubit.toggleShuffling();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, true);
      expect(actualPinpadKeyboardCubit.state.visibleNumbersList, isNot(sortedKeyboardNumbers));
    });

    test('Should [return PinpadKeyboardState] with unshuffled numbers (sorted again)', () {
      // Act
      actualPinpadKeyboardCubit.toggleShuffling();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, false);
      expect(actualPinpadKeyboardCubit.state.visibleNumbersList, sortedKeyboardNumbers);
    });

    test('Should [return PinpadKeyboardState] with shuffled numbers (different arrangement)', () {
      // Act
      actualPinpadKeyboardCubit.shuffle();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, true);
      expect(actualPinpadKeyboardCubit.state.visibleNumbersList, isNot(sortedKeyboardNumbers));

      // ******************************************************************************************

      // Act
      List<int> actualPreviousNumbers = actualPinpadKeyboardCubit.state.visibleNumbersList;
      actualPinpadKeyboardCubit.shuffle();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, true);
      expect(actualPinpadKeyboardCubit.state.visibleNumbersList, isNot(actualPreviousNumbers));
      expect(actualPinpadKeyboardCubit.state.visibleNumbersList, isNot(sortedKeyboardNumbers));

      // ******************************************************************************************

      // Act
      actualPreviousNumbers = actualPinpadKeyboardCubit.state.visibleNumbersList;
      actualPinpadKeyboardCubit.shuffle();

      // Assert
      expect(actualPinpadKeyboardCubit.state.shuffleEnabledBool, true);
      expect(actualPinpadKeyboardCubit.state.visibleNumbersList, isNot(actualPreviousNumbers));
      expect(actualPinpadKeyboardCubit.state.visibleNumbersList, isNot(sortedKeyboardNumbers));
    });
  });
}
