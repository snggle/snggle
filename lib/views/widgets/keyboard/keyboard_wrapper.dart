import 'package:flutter/cupertino.dart';
import 'package:snggle/views/widgets/keyboard/keyboard.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';

class KeyboardWrapper extends StatefulWidget {
  final List<String> availableHints;
  final KeyboardValueNotifier keyboardValueNotifier;
  final Widget child;

  const KeyboardWrapper({
    required this.availableHints,
    required this.keyboardValueNotifier,
    required this.child,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _KeyboardWrapperState();
}

class _KeyboardWrapperState extends State<KeyboardWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    widget.keyboardValueNotifier.addListener(_handleKeyboardVisibilityChange);
  }

  @override
  void dispose() {
    animationController.dispose();
    widget.keyboardValueNotifier.removeListener(_handleKeyboardVisibilityChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ValueListenableBuilder<bool>(
          valueListenable: widget.keyboardValueNotifier,
          builder: (BuildContext context, bool customKeyboardVisibleBool, _) {
            return Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: customKeyboardVisibleBool ? const EdgeInsets.only(bottom: Keyboard.height) : EdgeInsets.zero,
                child: widget.child,
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animationController),
            child: GestureDetector(
              onTap: () {},
              child: Keyboard(
                keyboardValueNotifier: widget.keyboardValueNotifier,
                availableHints: widget.availableHints,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleKeyboardVisibilityChange() async {
    bool keyboardVisibleBool = widget.keyboardValueNotifier.isVisible();
    if (keyboardVisibleBool) {
      await animationController.forward();
    } else {
      await animationController.reverse();
    }
  }
}
