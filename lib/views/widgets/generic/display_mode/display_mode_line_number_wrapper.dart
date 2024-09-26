import 'package:flutter/cupertino.dart';

class DisplayModeLineNumberWrapper extends StatelessWidget {
  final int lineNumber;
  final int totalLinesLength;
  final TextStyle? textStyle;
  final Widget child;
  final bool visibleBool;

  const DisplayModeLineNumberWrapper({
    required this.lineNumber,
    required this.totalLinesLength,
    required this.textStyle,
    required this.child,
    this.visibleBool = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          if (visibleBool) ...<Widget>[
            Container(
              height: double.infinity,
              color: const Color(0xfff3f3f3),
              width: switch (totalLinesLength) {
                < 10 => 18,
                (_) => 24,
              },
              child: Text(
                '${lineNumber + 1}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: textStyle?.copyWith(height: 1.48),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Expanded(child: child),
        ],
      ),
    );
  }
}
