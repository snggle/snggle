import 'package:flutter/cupertino.dart';

typedef CustomFlexibleGridItemBuilder = Widget Function(BuildContext context, int index);

class CustomFlexibleGrid extends StatelessWidget {
  final int columnsCount;
  final double verticalGap;
  final double horizontalGap;
  final int? childCount;
  final List<Widget>? children;
  final CustomFlexibleGridItemBuilder? itemBuilder;
  final bool buildOverflowCellsBool;

  const CustomFlexibleGrid({
    required this.columnsCount,
    required this.verticalGap,
    required this.horizontalGap,
    required List<Widget> this.children,
    this.buildOverflowCellsBool = false,
    super.key,
  })  : childCount = null,
        itemBuilder = null;

  const CustomFlexibleGrid.builder({
    required this.childCount,
    required this.columnsCount,
    required this.verticalGap,
    required this.horizontalGap,
    required CustomFlexibleGridItemBuilder this.itemBuilder,
    this.buildOverflowCellsBool = false,
    super.key,
  }) : children = null;

  @override
  Widget build(BuildContext context) {
    int cellsCount = children?.length ?? childCount!;
    int rowsCount = (cellsCount / columnsCount).ceil();

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

                      if (index < cellsCount || buildOverflowCellsBool) {
                        return Expanded(
                          child: children?[index] ?? itemBuilder!(context, index),
                        );
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
