import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/generic/display_mode/display_mode_line_number_wrapper.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_config.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_lines_list/text_lines_list_item.dart';

class TextLinesList extends StatelessWidget {
  final String inputText;
  final TextDisplayModeConfig textDisplayModeConfig;
  final TextStyle? textStyle;

  const TextLinesList({
    required this.inputText,
    required this.textDisplayModeConfig,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> lines = _calcTextLines(context);
    int totalLinesLength = lines.length;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalLinesLength,
      itemBuilder: (BuildContext context, int index) {
        return DisplayModeLineNumberWrapper(
          lineNumber: index,
          totalLinesLength: lines.length,
          textStyle: textStyle,
          visibleBool: textDisplayModeConfig.lineNumbersEnabledBool,
          child: lines[index],
        );
      },
    );
  }

  List<Widget> _calcTextLines(BuildContext context) {
    List<Widget> textSpans = <Widget>[];
    List<String> textLines = inputText.split('\n');

    for (int lineIndex = 0; lineIndex < textLines.length; lineIndex++) {
      textSpans.add(TextLinesListItem(
        lastLineBool: lineIndex == textLines.length - 1,
        spacesEnabledBool: textDisplayModeConfig.spacesEnabledBool,
        tabsEnabledBool: textDisplayModeConfig.tabsEnabledBool,
        newLinesEnabledBool: textDisplayModeConfig.newLinesEnabledBool,
        text: textLines[lineIndex],
        textStyle: textStyle,
      ));
    }
    return textSpans;
  }
}
