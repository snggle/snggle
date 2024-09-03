import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_cubit.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/button/shuffle_button.dart';
import 'package:snggle/views/widgets/custom/custom_flexible_grid.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
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
              child: CustomFlexibleGrid(
                horizontalGap: 12.5,
                verticalGap: 12,
                columnsCount: 3,
                children: <Widget>[
                  for (int i = 1; i <= 9; i++)
                    PinpadKeyboardButton.number(
                      number: visibleNumbers[i],
                      onTap: () => _handleNumberPressed(visibleNumbers[i]),
                    ),
                  const SizedBox(),
                  PinpadKeyboardButton.number(
                    number: visibleNumbers[0],
                    onTap: () => _handleNumberPressed(visibleNumbers[0]),
                  ),
                  PinpadKeyboardButton.icon(
                    icon: AssetIcon(AppIcons.keyboard_delete, color: AppColors.middleGrey, size: 26),
                    onTap: widget.onBackspacePressed,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleNumberPressed(int number) {
    widget.onNumberPressed.call(number);
    if (pinpadKeyboardCubit.state.shuffleEnabledBool) {
      pinpadKeyboardCubit.shuffle();
    }
  }
}
