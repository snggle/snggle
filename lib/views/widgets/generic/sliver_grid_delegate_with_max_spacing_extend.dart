import 'package:flutter/rendering.dart';

class SliverGridDelegateWithMaxSpacingExtend extends SliverGridDelegate {
  final double minimalHorizontalSpacing;
  final double minimalVerticalSpacing;
  final Size itemSize;

  SliverGridDelegateWithMaxSpacingExtend({
    required this.minimalHorizontalSpacing,
    required this.minimalVerticalSpacing,
    required this.itemSize,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    double gridWidth = constraints.crossAxisExtent;
    int columnsCount = getColumnsCount(gridWidth);
    int spacingsCount = columnsCount - 1;

    double totalColumnsWidth = columnsCount * itemSize.width;
    double totalSpacingWidth = gridWidth - totalColumnsWidth;

    double spacingSize = (totalSpacingWidth / spacingsCount).floorToDouble();

    double horizontalSpacingSize = itemSize.width + spacingSize;
    double verticalSpacingSize = itemSize.height + minimalVerticalSpacing;

    return SliverGridRegularTileLayout(
      crossAxisCount: columnsCount,
      mainAxisStride: verticalSpacingSize,
      crossAxisStride: horizontalSpacingSize,
      childMainAxisExtent: itemSize.height,
      childCrossAxisExtent: itemSize.width,
      reverseCrossAxis: false,
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithMaxSpacingExtend oldDelegate) {
    return oldDelegate.minimalHorizontalSpacing != minimalHorizontalSpacing ||
        oldDelegate.minimalVerticalSpacing != minimalVerticalSpacing ||
        oldDelegate.itemSize != itemSize;
  }

  int getColumnsCount(double width) {
    int columnsCount = 0;
    double totalWidth = 0;

    while (totalWidth < width) {
      if (columnsCount != 0) {
        totalWidth += minimalHorizontalSpacing;
      }
      if (totalWidth + itemSize.width < width) {
        totalWidth += itemSize.width;
        columnsCount++;
      } else {
        break;
      }
    }

    return columnsCount;
  }

  int getRowsCount(double height) {
    int rowsCount = 0;
    double totalHeight = 0;

    while (totalHeight < height) {
      if (rowsCount != 0) {
        totalHeight += minimalVerticalSpacing;
      }
      if (totalHeight + itemSize.height < height) {
        totalHeight += itemSize.height;
        rowsCount++;
      } else {
        break;
      }
    }

    return rowsCount;
  }
}
