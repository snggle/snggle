import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/keyboard/keyboard_cubit.dart';
import 'package:snggle/bloc/widgets/keyboard/keyboard_state.dart';
import 'package:snggle/views/widgets/button/shuffle_button.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_buttons_area.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_hints_area.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';

class Keyboard extends StatefulWidget {
  static const double height = 300;

  final List<String> availableHints;
  final KeyboardValueNotifier keyboardValueNotifier;

  const Keyboard({
    required this.availableHints,
    required this.keyboardValueNotifier,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  late KeyboardCubit keyboardCubit = KeyboardCubit(
    keyboardValueNotifier: widget.keyboardValueNotifier,
    availableHints: widget.availableHints,
  );

  @override
  void dispose() {
    keyboardCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeyboardCubit, KeyboardState>(
      bloc: keyboardCubit,
      builder: (BuildContext context, KeyboardState keyboardState) {
        return Container(
          height: Keyboard.height,
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 42,
                child: KeyboardHintsArea(
                  onHintSelected: keyboardCubit.acceptHint,
                  hints: keyboardState.hints,
                ),
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: ShuffleButton(
                    shuffleEnabledBool: keyboardState.shufflingEnabledBool,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      keyboardCubit.toggleShuffling();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: KeyboardButtonsArea(
                  alphabet: keyboardState.alphabet,
                  enabledLetters: keyboardState.enabledLetters,
                  onLetterTap: _handleKeyboardButtonTap,
                  onHideKeyboardTap: widget.keyboardValueNotifier.hideKeyboard,
                  onBackspaceTap: keyboardCubit.removeLastLetter,
                  onBackspaceLongPress: _handleBackspaceLongPress,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleKeyboardButtonTap(String letter) {
    keyboardCubit.addLetter(letter);
  }

  void _handleBackspaceLongPress() {
    keyboardCubit.clear();
  }
}
