import 'package:flutter/cupertino.dart';

class KeyboardValueNotifier extends ValueNotifier<bool> {
  TextEditingController? _textEditingController;
  FocusNode? _previousFocusNode;
  FocusNode? _currentFocusNode;
  FocusNode? _nextFocusNode;

  KeyboardValueNotifier({
    TextEditingController? textEditingController,
  }) : super(false) {
    _textEditingController = textEditingController;
  }

  void focusPrevious() {
    _previousFocusNode?.requestFocus();
  }

  void focusNext() {
    _currentFocusNode?.unfocus();
    if (_nextFocusNode != null) {
      _nextFocusNode?.requestFocus();
    } else {
      hideKeyboard();
    }
  }

  bool isFocused(FocusNode focusNode) => focusNode == _currentFocusNode;

  bool isVisible() => value;

  void showKeyboard({
    required TextEditingController textEditingController,
    required FocusNode currentFocusNode,
    FocusNode? previousFocusNode,
    FocusNode? nextFocusNode,
  }) {
    _textEditingController = textEditingController;
    _previousFocusNode = previousFocusNode;
    _currentFocusNode = currentFocusNode;
    _nextFocusNode = nextFocusNode;

    value = true;
  }

  void hideKeyboard() {
    _currentFocusNode?.unfocus();
    value = false;
    _clear();
  }

  String get text => _textEditingController?.text ?? '';

  set text(String value) => _textEditingController?.text = value;

  void _clear() {
    _previousFocusNode = null;
    _currentFocusNode = null;
    _nextFocusNode = null;
  }
}
