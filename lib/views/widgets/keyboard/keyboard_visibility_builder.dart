import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';

typedef KeyboardVisibilityChildBuilder = Widget Function({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool});

class KeyboardVisibilityBuilder extends StatefulWidget {
  final KeyboardVisibilityChildBuilder builder;
  final KeyboardValueNotifier? keyboardValueNotifier;

  const KeyboardVisibilityBuilder({
    required this.builder,
    this.keyboardValueNotifier,
    super.key,
  });

  static KeyboardVisibilityBuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<KeyboardVisibilityBuilderState>()!;
  }

  @override
  State<StatefulWidget> createState() => KeyboardVisibilityBuilderState();
}

class KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder> with WidgetsBindingObserver {
  bool keyboardVisibleBool = false;
  late Completer<void> keyboardCompleter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    keyboardCompleter = Completer<void>()..complete();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    double bottomInset = View.of(context).viewInsets.bottom;
    bool newValue = bottomInset > 0.0;
    if (newValue != keyboardVisibleBool) {
      setState(() => keyboardVisibleBool = newValue);
      if (newValue == true) {
        keyboardCompleter = Completer<void>();
      } else {
        keyboardCompleter.complete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.keyboardValueNotifier == null) {
      return widget.builder(
        customKeyboardVisibleBool: false,
        nativeKeyboardVisibleBool: keyboardVisibleBool,
      );
    } else {
      return ValueListenableBuilder<bool>(
        valueListenable: widget.keyboardValueNotifier!,
        builder: (BuildContext context, bool customKeyboardVisibleBool, _) {
          return widget.builder(
            customKeyboardVisibleBool: customKeyboardVisibleBool,
            nativeKeyboardVisibleBool: keyboardVisibleBool,
          );
        },
      );
    }
  }
}
