import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_lines_list/whitespace_icon.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class TextLinesListItem extends StatelessWidget {
  final bool lastLineBool;
  final bool spacesEnabledBool;
  final bool tabsEnabledBool;
  final bool newLinesEnabledBool;
  final String text;
  final TextStyle? textStyle;

  const TextLinesListItem({
    required this.lastLineBool,
    required this.spacesEnabledBool,
    required this.tabsEnabledBool,
    required this.newLinesEnabledBool,
    required this.text,
    required this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> lineSpans = <InlineSpan>[];

    for (int charIndex = 0; charIndex < text.length; charIndex++) {
      String char = text[charIndex];

      if (char == ' ' && spacesEnabledBool) {
        lineSpans.add(const WhitespaceIcon(AppIcons.text_space, size: 2).getWidgetSpan());
      } else if (char == '\t' && tabsEnabledBool) {
        lineSpans.add(const WhitespaceIcon(AppIcons.text_tab, width: 16, height: 8).getWidgetSpan());
      } else if (char == '\r' && newLinesEnabledBool) {
        lineSpans.add(const WhitespaceIcon(AppIcons.text_wrap, width: 12, height: 16).getWidgetSpan());
      } else {
        lineSpans.add(TextSpan(text: char));
      }
    }

    if (lastLineBool == false && newLinesEnabledBool) {
      lineSpans.add(
        const WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: AssetIcon(AppIcons.text_new_line),
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: textStyle?.copyWith(color: AppColors.body3, height: 1.48),
        children: lineSpans,
      ),
    );
  }
}
