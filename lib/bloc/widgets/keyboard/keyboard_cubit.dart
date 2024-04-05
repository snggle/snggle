import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/keyboard/keyboard_state.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';

class KeyboardCubit extends Cubit<KeyboardState> {
  static final List<String> alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

  final List<String> availableHints;
  final KeyboardValueNotifier keyboardValueNotifier;

  KeyboardCubit({
    required this.availableHints,
    required this.keyboardValueNotifier,
    bool initialShufflingEnabledBool = false,
    List<String>? customAlphabet,
  }) : super(KeyboardState(
          shufflingEnabledBool: initialShufflingEnabledBool,
          alphabet: customAlphabet ?? alphabet,
          enabledLetters: _filterEnabledLetters(availableHints, keyboardValueNotifier.text),
          hints: _filterHints(availableHints, keyboardValueNotifier.text),
        )) {
    keyboardValueNotifier.addListener(_handleKeyboardVisibilityChanged);
  }

  @override
  Future<void> close() {
    keyboardValueNotifier.removeListener(_handleKeyboardVisibilityChanged);
    return super.close();
  }

  void addLetter(String letter) {
    String newText = '${keyboardValueNotifier.text}$letter';
    _updateKeyboardState(newText);
    _validateState();
  }

  void acceptHint(String hint) {
    _updateKeyboardState(hint);
    keyboardValueNotifier.focusNext();
  }

  void clear() {
    _updateKeyboardState('');
  }

  void removeLastLetter() {
    String newText = keyboardValueNotifier.text;
    if (newText.isEmpty) {
      keyboardValueNotifier.focusPrevious();
    } else {
      newText = newText.substring(0, newText.length - 1);
    }

    _updateKeyboardState(newText);
  }

  void toggleShuffling() {
    emit(KeyboardState(
      shufflingEnabledBool: state.shufflingEnabledBool == false,
      alphabet: state.shufflingEnabledBool ? (List<String>.from(alphabet)..shuffle()) : alphabet,
      enabledLetters: state.enabledLetters,
      hints: state.hints,
    ));

    _updateKeyboardState(keyboardValueNotifier.text);
  }

  static List<String> _filterEnabledLetters(List<String> hints, String newText) {
    List<String> filteredHints = _filterHints(hints, newText);
    return filteredHints
        .map((String hint) {
          return (hint.split('').elementAtOrNull(newText.length) ?? '').toUpperCase();
        })
        .where((String letter) => letter.isNotEmpty)
        .toSet()
        .toList();
  }

  static List<String> _filterHints(List<String> hints, String newText) {
    return hints.where((String word) => word.toUpperCase().startsWith(newText.toUpperCase())).toList();
  }

  void _handleKeyboardVisibilityChanged() {
    String textFieldValue = keyboardValueNotifier.text;
    _updateKeyboardState(textFieldValue);
  }

  void _updateKeyboardState(String newText) {
    List<String> hints = _filterHints(availableHints, newText);
    keyboardValueNotifier.text = newText.toLowerCase();
    List<String> enabledLetters = _filterEnabledLetters(availableHints, newText);

    emit(KeyboardState(
      shufflingEnabledBool: state.shufflingEnabledBool,
      alphabet: state.shufflingEnabledBool ? (List<String>.from(alphabet)..shuffle()) : alphabet,
      enabledLetters: enabledLetters,
      hints: hints,
    ));
  }

  void _validateState() {
    if (state.hints.length == 1) {
      keyboardValueNotifier
        ..text = state.hints.first.toLowerCase()
        ..focusNext();
    }
  }
}
