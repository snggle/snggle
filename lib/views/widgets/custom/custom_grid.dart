import 'package:flutter/cupertino.dart';

typedef CustomGridItemBuilder = Widget Function(BuildContext context, int index);

class CustomGrid extends StatelessWidget {
  final int columnsCount;
  final int childCount;
  final bool buildEmptyCellsBool;
  final double verticalGap;
  final double horizontalGap;
  final CustomGridItemBuilder itemBuilder;
  final ValueChanged<int>? onTap;

  const CustomGrid.builder({
    required this.columnsCount,
    required this.childCount,
    required this.itemBuilder,
    this.buildEmptyCellsBool = false,
    this.verticalGap = 0,
    this.horizontalGap = 0,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int rowsCount = (childCount / columnsCount).ceil();

    return Column(
      children: <Widget>[
        for (int y = 0; y < rowsCount; y += 1)
          Row(
            children: <Widget>[
              for (int x = 0; x < columnsCount; x += 1)
                Expanded(
                  child: Builder(
                    builder: (BuildContext context) {
                      int index = y * columnsCount + x;
                      return (buildEmptyCellsBool || index < childCount)
                          ? GestureDetector(
                              onTap: () => onTap?.call(index),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: x == 0 ? 0 : horizontalGap,
                                  top: y == 0 ? 0 : verticalGap,
                                ),
                                child: itemBuilder(context, index),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
