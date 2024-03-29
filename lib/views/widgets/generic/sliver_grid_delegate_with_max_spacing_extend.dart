import 'package:flutter/rendering.dart';

class SliverGridDelegateWithMaxSpacingExtend extends SliverGridDelegate {
  final double minimalHorizontalSpacing;
  final double minimalVerticalSpacing;
  final double itemWidth;
  final double itemHeight;

  SliverGridDelegateWithMaxSpacingExtend({
    required this.minimalHorizontalSpacing,
    required this.minimalVerticalSpacing,
    required this.itemWidth,
    required this.itemHeight,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    double gridWidth = constraints.crossAxisExtent;
    double totalWidthPerItem = itemWidth + minimalHorizontalSpacing;
    int columnsCount = (gridWidth + minimalHorizontalSpacing) ~/ totalWidthPerItem;
    int spacingsCount = columnsCount - 1;

    double totalColumnsWidth = columnsCount * itemWidth;
    double totalSpacingWidth = gridWidth - totalColumnsWidth;

    double spacingSize = totalSpacingWidth / spacingsCount;

    double horizontalSpacingSize = itemWidth + spacingSize;
    double verticalSpacingSize = itemHeight + minimalVerticalSpacing;

    return SliverGridRegularTileLayout(
      crossAxisCount: columnsCount,
      mainAxisStride: verticalSpacingSize,
      crossAxisStride: horizontalSpacingSize,
      childMainAxisExtent: itemHeight,
      childCrossAxisExtent: itemWidth,
      reverseCrossAxis: false,
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithMaxSpacingExtend oldDelegate) {
    return oldDelegate.minimalHorizontalSpacing != minimalHorizontalSpacing ||
        oldDelegate.minimalVerticalSpacing != minimalVerticalSpacing ||
        oldDelegate.itemWidth != itemWidth ||
        oldDelegate.itemHeight != itemHeight;
  }
}
