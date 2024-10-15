import 'package:flutter/cupertino.dart';

class LegacyDerivationPathOverflowText extends StatelessWidget {
  final String derivationPath;
  final TextAlign textAlign;
  final TextStyle textStyle;

  const LegacyDerivationPathOverflowText({
    required this.derivationPath,
    required this.textAlign,
    required this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints size) {
        String text = _getVisibleDerivationPath(size);

        return Text(
          text,
          textAlign: textAlign,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );
      },
    );
  }

  String _getVisibleDerivationPath(BoxConstraints size) {
    List<String> textSections = derivationPath.toString().split('/');
    String text = textSections.join('/');

    TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.maxWidth);

    while (painter.didExceedMaxLines && textSections.isNotEmpty) {
      textSections.removeAt(0);
      text = '.../${textSections.join('/')}';
      painter
        ..text = TextSpan(text: text, style: textStyle)
        ..layout(maxWidth: size.maxWidth);
    }

    if (textSections.isNotEmpty) {
      return text;
    } else {
      return '...';
    }
  }
}
