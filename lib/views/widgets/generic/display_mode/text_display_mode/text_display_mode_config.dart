import 'package:equatable/equatable.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_type.dart';

class TextDisplayModeConfig extends Equatable {
  final bool lineNumbersEnabledBool;
  final bool newLinesEnabledBool;
  final bool tabsEnabledBool;
  final bool spacesEnabledBool;
  final TextDisplayModeType textDisplayModeType;

  factory TextDisplayModeConfig({
    bool? lineNumberVisible,
    bool? newlinesVisible,
    bool? tabsVisible,
    bool? spacesVisible,
    TextDisplayModeType textDisplayModeType = TextDisplayModeType.text,
  }) {
    if (textDisplayModeType == TextDisplayModeType.hex) {
      return const TextDisplayModeConfig._(
        textDisplayModeType: TextDisplayModeType.hex,
        lineNumbersEnabledBool: false,
        newLinesEnabledBool: false,
        tabsEnabledBool: false,
        spacesEnabledBool: false,
      );
    } else {
      return TextDisplayModeConfig._(
        textDisplayModeType: TextDisplayModeType.text,
        lineNumbersEnabledBool: lineNumberVisible ?? true,
        newLinesEnabledBool: newlinesVisible ?? true,
        tabsEnabledBool: tabsVisible ?? true,
        spacesEnabledBool: spacesVisible ?? true,
      );
    }
  }

  const TextDisplayModeConfig._({
    required this.lineNumbersEnabledBool,
    required this.newLinesEnabledBool,
    required this.tabsEnabledBool,
    required this.spacesEnabledBool,
    required this.textDisplayModeType,
  });

  TextDisplayModeConfig copyWith({
    bool? lineNumbersEnabledBool,
    bool? newLinesEnabledBool,
    bool? tabsEnabledBool,
    bool? spacesEnabledBool,
    TextDisplayModeType? textDisplayModeType,
  }) {
    return TextDisplayModeConfig(
      lineNumberVisible: lineNumbersEnabledBool ?? this.lineNumbersEnabledBool,
      newlinesVisible: newLinesEnabledBool ?? this.newLinesEnabledBool,
      tabsVisible: tabsEnabledBool ?? this.tabsEnabledBool,
      spacesVisible: spacesEnabledBool ?? this.spacesEnabledBool,
      textDisplayModeType: textDisplayModeType ?? this.textDisplayModeType,
    );
  }

  @override
  List<Object?> get props => <Object>[lineNumbersEnabledBool, newLinesEnabledBool, tabsEnabledBool, spacesEnabledBool, textDisplayModeType];
}
