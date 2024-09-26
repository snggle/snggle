import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/generic/display_mode/display_mode_line_number_wrapper.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/whitespaces_preview_list_item.dart';

class TextDisplayModeWhitespacesPreview extends StatelessWidget {
  final String inputText;
  final bool spacesEnabledBool;
  final bool tabsEnabledBool;
  final bool newLinesEnabledBool;
  final bool lineNumbersEnabledBool;
  final TextStyle? textStyle;

  const TextDisplayModeWhitespacesPreview({
    required this.inputText,
    this.spacesEnabledBool = true,
    this.tabsEnabledBool = true,
    this.newLinesEnabledBool = true,
    this.lineNumbersEnabledBool = true,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> lines = _parseText(context);
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
            visibleBool: lineNumbersEnabledBool,
            child: lines[index],
          );
        });
  }

  List<Widget> _parseText(BuildContext context) {
    List<Widget> textSpans = <Widget>[];
    List<String> textLines = inputText.split('\n');

    for (int lineIndex = 0; lineIndex < textLines.length; lineIndex++) {
      textSpans.add(WhitespacesPreviewListItem(
        lastLineBool: lineIndex == textLines.length - 1,
        spacesEnabledBool: spacesEnabledBool,
        tabsEnabledBool: tabsEnabledBool,
        newLinesEnabledBool: newLinesEnabledBool,
        text: textLines[lineIndex],
        textStyle: textStyle,
      ));
    }
    return textSpans;
  }
}
