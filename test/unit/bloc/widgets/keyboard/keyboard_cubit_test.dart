import 'package:blockchain_utils/bip/bip/bip39/bip39_mnemonic.dart';
import 'package:blockchain_utils/bip/bip/bip39/word_list/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/widgets/keyboard/keyboard_cubit.dart';
import 'package:snggle/bloc/widgets/keyboard/keyboard_state.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';

void main() {
  List<String> allKeyboardHints = bip39WordList(Bip39Languages.english);

  group('Test of KeyboardCubit process', () {
    KeyboardValueNotifier actualKeyboardValueNotifier = KeyboardValueNotifier(textEditingController: TextEditingController());
    KeyboardCubit actualKeyboardCubit = KeyboardCubit(availableHints: allKeyboardHints, keyboardValueNotifier: actualKeyboardValueNotifier);

    group('Tests of KeyboardCubit initialization', () {
      test('Should [return KeyboardCubit] with default values as initial state', () {
        // Assert
        KeyboardState expectedKeyboardState = KeyboardState(
          shufflingEnabledBool: false,
          alphabet: KeyboardCubit.alphabet,
          enabledLetters: 'ABCDEFGHIJKLMNOPQRSTUVWYZ'.split(''),
          hints: allKeyboardHints,
        );

        expect(actualKeyboardCubit.state, expectedKeyboardState);
      });
    });

    group('Tests of KeyboardCubit.addLetter()', () {
      test('Should [return KeyboardState] with updated values and add letter to TextEditingController', () {
        // Act
        actualKeyboardCubit.addLetter('y');

        // Assert
        KeyboardState expectedKeyboardState = KeyboardState(
          shufflingEnabledBool: false,
          alphabet: KeyboardCubit.alphabet,
          enabledLetters: 'AEO'.split(''),
          hints: const <String>['yard', 'year', 'yellow', 'you', 'young', 'youth'],
        );

        expect(actualKeyboardCubit.state, expectedKeyboardState);
        expect(actualKeyboardCubit.keyboardValueNotifier.text, 'y');
      });

      test('Should [return KeyboardState] with updated values and fill TextEditingController with hint if entered letters has only one hint', () {
        // Act
        actualKeyboardCubit.addLetter('a');

        // Assert
        KeyboardState expectedKeyboardState = KeyboardState(
          shufflingEnabledBool: false,
          alphabet: KeyboardCubit.alphabet,
          enabledLetters: const <String>['R'],
          hints: const <String>['yard'],
        );

        expect(actualKeyboardCubit.state, expectedKeyboardState);
        expect(actualKeyboardCubit.keyboardValueNotifier.text, 'yard');
      });
    });

    group('Tests of KeyboardCubit.acceptHint()', () {
      test('Should [return KeyboardState] with updated values and fill TextEditingController with selected hint', () {
        // Act
        actualKeyboardCubit.acceptHint('network');

        // Assert
        KeyboardState expectedKeyboardState = KeyboardState(
          shufflingEnabledBool: false,
          alphabet: KeyboardCubit.alphabet,
          enabledLetters: const <String>[],
          hints: const <String>['network'],
        );

        expect(actualKeyboardCubit.state, expectedKeyboardState);
        expect(actualKeyboardCubit.keyboardValueNotifier.text, 'network');
      });
    });

    group('Tests of KeyboardCubit.removeLastLetter()', () {
      test('Should [return KeyboardState] with updated values and remove last letter from TextEditingController', () {
        // Act
        actualKeyboardCubit.removeLastLetter();

        // Assert
        KeyboardState expectedKeyboardState = KeyboardState(
          shufflingEnabledBool: false,
          alphabet: KeyboardCubit.alphabet,
          enabledLetters: const <String>['K'],
          hints: const <String>['network'],
        );

        expect(actualKeyboardCubit.state, expectedKeyboardState);
        expect(actualKeyboardCubit.keyboardValueNotifier.text, 'networ');
      });
    });

    group('Tests of KeyboardCubit.clear()', () {
      test('Should [return KeyboardState] with empty values', () {
        // Act
        actualKeyboardCubit.clear();

        // Assert
        KeyboardState expectedKeyboardState = KeyboardState(
          shufflingEnabledBool: false,
          alphabet: KeyboardCubit.alphabet,
          enabledLetters: 'ABCDEFGHIJKLMNOPQRSTUVWYZ'.split(''),
          hints: allKeyboardHints,
        );

        expect(actualKeyboardCubit.state, expectedKeyboardState);
        expect(actualKeyboardCubit.keyboardValueNotifier.text, '');
      });
    });

    group('Tests of KeyboardCubit.toggleShuffling()', () {
      test('Should [return KeyboardState] with [shufflingEnabledBool == TRUE] and [SHUFFLED alphabet]', () {
        // Act
        actualKeyboardCubit.toggleShuffling();

        // Assert
        // Since shuffling randomly shuffles the alphabet, we can't predict the exact outcome.
        // For that reason we only check if the alphabet is different from the default one
        expect(actualKeyboardCubit.state.shufflingEnabledBool, true);
        expect(actualKeyboardCubit.state.alphabet, isNot(KeyboardCubit.alphabet));
      });

      test('Should [return KeyboardState] with [shufflingEnabledBool == FALSE] and [SORTED alphabet]', () {
        // Act
        actualKeyboardCubit.toggleShuffling();

        // Assert
        KeyboardState expectedKeyboardState = KeyboardState(
          shufflingEnabledBool: false,
          alphabet: KeyboardCubit.alphabet,
          enabledLetters: 'ABCDEFGHIJKLMNOPQRSTUVWYZ'.split(''),
          hints: allKeyboardHints,
        );

        expect(actualKeyboardCubit.state, expectedKeyboardState);
      });
    });
  });
}
