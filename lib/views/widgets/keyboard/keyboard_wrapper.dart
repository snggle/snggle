import 'package:flutter/cupertino.dart';
import 'package:snggle/views/widgets/keyboard/keyboard.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';

class KeyboardWrapper extends StatefulWidget {
  final List<String> _availableHints;
  final KeyboardValueNotifier _keyboardValueNotifier;
  final Widget _child;

  const KeyboardWrapper({
    required this._availableHints,
    required this._keyboardValueNotifier,
    required this._child,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _KeyboardWrapperState();
}

class _KeyboardWrapperState extends State<KeyboardWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    widget._keyboardValueNotifier.addListener(_handleKeyboardVisibilityChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget._keyboardValueNotifier.removeListener(_handleKeyboardVisibilityChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ValueListenableBuilder<bool>(
          valueListenable: widget._keyboardValueNotifier,
          builder: (BuildContext context, bool customKeyboardVisibleBool, _) {
            return Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: customKeyboardVisibleBool ? const EdgeInsets.only(bottom: Keyboard.height) : EdgeInsets.zero,
                child: widget._child,
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRect(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(_animationController),
              child: GestureDetector(
                onTap: () {},
                child: Keyboard(
                  keyboardValueNotifier: widget._keyboardValueNotifier,
                  availableHints: widget._availableHints,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleKeyboardVisibilityChange() async {
    bool keyboardVisibleBool = widget._keyboardValueNotifier.isVisible();
    if (keyboardVisibleBool) {
      await _animationController.forward();
    } else {
      await _animationController.reverse();
    }
  }
}
