import 'package:flutter/cupertino.dart';

class CustomFlexibleGrid extends StatelessWidget {
  final int columnsCount;
  final double verticalGap;
  final double horizontalGap;
  final List<Widget> children;

  const CustomFlexibleGrid({
    required this.columnsCount,
    required this.verticalGap,
    required this.horizontalGap,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int rowsCount = (children.length / columnsCount).ceil();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (int y = 0; y < rowsCount; y++) ...<Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                for (int x = 0; x < columnsCount; x++) ...<Widget>[
                  Builder(
                    builder: (BuildContext context) {
                      int index = y * columnsCount + x;

                      if (index < children.length) {
                        return Expanded(child: children[index]);
                      } else {
                        return const Spacer();
                      }
                    },
                  ),
                  if (x < columnsCount - 1) SizedBox(width: horizontalGap),
                ],
              ],
            ),
          ),
          if (y < rowsCount - 1) SizedBox(height: verticalGap),
        ],
      ],
    );
  }
}
