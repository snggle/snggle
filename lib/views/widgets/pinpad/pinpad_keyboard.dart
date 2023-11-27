import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_cubit.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/button/shuffle_button.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_keyboard_button.dart';

class PinpadKeyboard extends StatefulWidget {
  final ValueChanged<int> onNumberPressed;
  final VoidCallback onBackspacePressed;

  const PinpadKeyboard({
    required this.onNumberPressed,
    required this.onBackspacePressed,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PinpadKeyboardState();
}

class _PinpadKeyboardState extends State<PinpadKeyboard> {
  final PinpadKeyboardCubit pinpadKeyboardCubit = PinpadKeyboardCubit();

  @override
  void dispose() {
    pinpadKeyboardCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinpadKeyboardCubit, PinpadKeyboardState>(
      bloc: pinpadKeyboardCubit,
      builder: (BuildContext context, PinpadKeyboardState pinpadKeyboardState) {
        List<int> visibleNumbers = pinpadKeyboardState.visibleNumbers;
        return Column(
          children: <Widget>[
            ShuffleButton(
              onPressed: pinpadKeyboardCubit.toggleShuffling,
              shuffleEnabledBool: pinpadKeyboardState.shuffleEnabledBool,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildRow(<int>[visibleNumbers[1], visibleNumbers[2], visibleNumbers[3]]),
                  _buildRow(<int>[visibleNumbers[4], visibleNumbers[5], visibleNumbers[6]]),
                  _buildRow(<int>[visibleNumbers[7], visibleNumbers[8], visibleNumbers[9]]),
                  _buildSpecialRow(visibleNumbers[0]),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow(List<int> rowNumbers) {
    return Expanded(
      child: Row(
        children: <Widget>[
          for (int i = 0; i < rowNumbers.length; i++)
            Expanded(
              child: PinpadKeyboardButton.number(
                number: rowNumbers[i],
                onTap: () => _handleNumberPressed(rowNumbers[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpecialRow(int number) {
    return Expanded(
      child: Row(
        children: <Widget>[
          const Expanded(child: SizedBox()),
          Expanded(
            child: PinpadKeyboardButton.number(
              number: number,
              onTap: () => _handleNumberPressed(number),
            ),
          ),
          Expanded(
            child: PinpadKeyboardButton.icon(
              icon: Icon(AppIcons.delete_1, color: AppColors.middleGrey, size: 26),
              onTap: widget.onBackspacePressed,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNumberPressed(int number) {
    widget.onNumberPressed.call(number);
    if (pinpadKeyboardCubit.state.shuffleEnabledBool) {
      pinpadKeyboardCubit.shuffle();
    }
  }
}
