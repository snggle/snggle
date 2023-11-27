import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:sprung/sprung.dart';

class ShuffleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool shuffleEnabledBool;

  const ShuffleButton({
    required this.onPressed,
    this.shuffleEnabledBool = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      'SHUFFLE',
      style: TextStyle(
        fontSize: 14,
        letterSpacing: 5,
        height: 1.71,
        fontWeight: FontWeight.w400,
        color: AppColors.body3,
      ),
    );

    Widget unshuffledButton = Visibility.maintain(
      key: const ValueKey<String?>('unshuffled'),
      visible: true,
      child: textWidget,
    );

    Widget shuffledButton = Visibility.maintain(
      key: const ValueKey<String?>('shuffled'),
      visible: true,
      child: Transform.scale(
        scaleY: -1,
        child: textWidget,
      ),
    );

    Widget shuffleButtonWidget = AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: Duration.zero,
      switchInCurve: Sprung.custom(mass: 1, stiffness: 600, damping: 15),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          key: ValueKey<Key?>(child.key),
          scale: animation,
          child: child,
        );
      },
      child: shuffleEnabledBool ? shuffledButton : unshuffledButton,
    );

    return SizedBox(
      width: 100,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Center(child: shuffleButtonWidget),
      ),
    );
  }
}
