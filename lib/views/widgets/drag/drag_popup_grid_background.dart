import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/sliver_grid_delegate_with_max_spacing_extend.dart';

class DragPopupGridBackground extends StatelessWidget {
  final double minimalVerticalSpacing;
  final double minimalHorizontalSpacing;
  final Size itemSize;

  const DragPopupGridBackground({
    required this.minimalVerticalSpacing,
    required this.minimalHorizontalSpacing,
    required this.itemSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SliverGridDelegateWithMaxSpacingExtend sliverGridDelegateWithMaxSpacingExtend = SliverGridDelegateWithMaxSpacingExtend(
      minimalVerticalSpacing: minimalVerticalSpacing,
      minimalHorizontalSpacing: minimalHorizontalSpacing,
      itemSize: itemSize,
    );

    Widget gridDot = Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightGrey2,
      ),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int rowsCount = sliverGridDelegateWithMaxSpacingExtend.getRowsCount(constraints.maxHeight);
        int verticalSpacingsCount = rowsCount + 1;
        int verticalElementsCount = rowsCount + verticalSpacingsCount;

        int columnsCount = sliverGridDelegateWithMaxSpacingExtend.getColumnsCount(constraints.maxWidth);
        int horizontalSpacingsCount = columnsCount - 1;
        int horizontalElementsCount = columnsCount + horizontalSpacingsCount;

        return Column(
          children: <Widget>[
            for (int y = 0; y < verticalElementsCount; y++)
              if (y.isOdd)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (int x = 0; x < horizontalElementsCount; x++)
                      if (x.isEven) SizedBox.fromSize(size: itemSize) else const Spacer(),
                  ],
                )
              else
                Row(
                  children: <Widget>[
                    for (int x = 0; x < horizontalElementsCount; x++)
                      if (x.isEven) SizedBox(width: itemSize.width) else Expanded(child: gridDot)
                  ],
                )
          ],
        );
      },
    );
  }
}
