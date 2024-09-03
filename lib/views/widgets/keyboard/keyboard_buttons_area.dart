import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_flexible_grid.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_button.dart';

class KeyboardButtonsArea extends StatelessWidget {
  final List<String> alphabet;
  final List<String> enabledLetters;
  final ValueChanged<String> onLetterTap;
  final VoidCallback onHideKeyboardTap;
  final VoidCallback onBackspaceTap;
  final VoidCallback onBackspaceLongPress;

  const KeyboardButtonsArea({
    required this.alphabet,
    required this.enabledLetters,
    required this.onLetterTap,
    required this.onHideKeyboardTap,
    required this.onBackspaceTap,
    required this.onBackspaceLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int letterIndex = 0;

    return CustomFlexibleGrid.builder(
      childCount: alphabet.length + 1,
      columnsCount: 6,
      horizontalGap: 1.4,
      verticalGap: 1.4,
      buildOverflowCellsBool: true,
      itemBuilder: (BuildContext context, int index) {
        bool bottomBool = index >= 24;
        bool centerBool = index % 6 == 2 || index % 6 == 3;

        bool hideKeyboardButtonBool = bottomBool && index % 6 == 0;
        bool backspaceButtonBool = bottomBool && index % 6 == 5;
        bool letterButtonBool = index < 24 || (bottomBool && centerBool);

        if (hideKeyboardButtonBool) {
          return KeyboardButton(
            disabledBool: false,
            onTap: onHideKeyboardTap,
            child: AssetIcon(AppIcons.keyboard_collapse, color: AppColors.body1, size: 23),
          );
        } else if (backspaceButtonBool) {
          return KeyboardButton(
            disabledBool: false,
            onTap: onBackspaceTap,
            onLongPress: onBackspaceLongPress,
            child: AssetIcon(AppIcons.keyboard_delete, color: AppColors.body1, size: 23),
          );
        } else if (letterButtonBool) {
          int currentLetterIndex = letterIndex++;
          String letter = alphabet.elementAt(currentLetterIndex);
          bool disabledBool = enabledLetters.contains(letter) == false;

          return KeyboardButton(
            key: ValueKey<String>('keyboard$letter'),
            disabledBool: disabledBool,
            onTap: () => onLetterTap(letter),
            child: Text(
              alphabet.elementAtOrNull(currentLetterIndex) ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: disabledBool ? AppColors.lightGrey2 : AppColors.body1,
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
