import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_type.dart';

class TextDisplayModeConfig extends ChangeNotifier {
  late bool _lineNumbersEnabledBool;
  late bool _newLinesEnabledBool;
  late bool _tabsEnabledBool;
  late bool _spacesEnabledBool;
  late TextDisplayModeType _textDisplayModeType;

  TextDisplayModeConfig({
    bool lineNumberVisible = true,
    bool newlinesVisible = true,
    bool tabsVisible = true,
    bool spacesVisible = true,
    TextDisplayModeType displayMode = TextDisplayModeType.text,
  })  : _textDisplayModeType = displayMode,
        _spacesEnabledBool = spacesVisible,
        _tabsEnabledBool = tabsVisible,
        _newLinesEnabledBool = newlinesVisible,
        _lineNumbersEnabledBool = lineNumberVisible;

  TextDisplayModeConfig copy() {
    return TextDisplayModeConfig(
      lineNumberVisible: _lineNumbersEnabledBool,
      newlinesVisible: _newLinesEnabledBool,
      tabsVisible: _tabsEnabledBool,
      spacesVisible: _spacesEnabledBool,
      displayMode: _textDisplayModeType,
    );
  }

  bool get areLineNumbersEnabled => _lineNumbersEnabledBool;

  set lineNumbersEnabled(bool value) {
    _lineNumbersEnabledBool = value;
    notifyListeners();
  }

  bool get areNewLinesEnabled => _newLinesEnabledBool;

  set newLinesEnabled(bool value) {
    _newLinesEnabledBool = value;
    notifyListeners();
  }

  bool get areTabsEnabled => _tabsEnabledBool;

  set tabsEnabled(bool value) {
    _tabsEnabledBool = value;
    notifyListeners();
  }

  bool get areSpacesEnabled => _spacesEnabledBool;

  set spacesEnabled(bool value) {
    _spacesEnabledBool = value;
    notifyListeners();
  }

  TextDisplayModeType get textDisplayModeType => _textDisplayModeType;

  set textDisplayModeType(TextDisplayModeType value) {
    _textDisplayModeType = value;

    if (value == TextDisplayModeType.hex) {
      _lineNumbersEnabledBool = false;
      _newLinesEnabledBool = false;
      _tabsEnabledBool = false;
      _spacesEnabledBool = false;
    } else {
      _lineNumbersEnabledBool = true;
      _newLinesEnabledBool = true;
      _tabsEnabledBool = true;
      _spacesEnabledBool = true;
    }

    notifyListeners();
  }
}
