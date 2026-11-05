import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/views/widgets/custom/custom_flexible_grid.dart';
import 'package:snggle/views/widgets/icons/container_icon_content_preview.dart';

class ContainerIconGrid extends StatelessWidget {
  final List<Widget> contentPreview;
  final List<AListItemModel> listItemsPreview;
  final EdgeInsets padding;

  const ContainerIconGrid({
    required this.listItemsPreview,
    required this.padding,
    super.key,
  }) : contentPreview = const <Widget>[];

  const ContainerIconGrid.fromContentPreview({
    required this.contentPreview,
    required this.padding,
    super.key,
  }) : listItemsPreview = const <AListItemModel>[];

  @override
  Widget build(BuildContext context) {
    List<Widget> previewWidgetList = <Widget>[];

    if (listItemsPreview.isEmpty) {
      previewWidgetList.addAll(contentPreview);
    } else {
      for (AListItemModel listItemModel in listItemsPreview) {
        previewWidgetList.add(ContainerIconContentPreview(listItemModel: listItemModel));
      }
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double innerWidth = constraints.maxWidth - padding.horizontal;
        double innerHeight = constraints.maxHeight - padding.vertical;

        double gridSize = min(innerWidth, innerHeight);
        double spacing = gridSize * 0.13;

        int slotsPerSide = _calcSlotsPerSide(previewWidgetList.length);
        int slotsCount = slotsPerSide * slotsPerSide;

        return Padding(
          padding: padding,
          child: Center(
            child: SizedBox(
              width: gridSize,
              height: gridSize,
              child: CustomFlexibleGrid.builder(
                columnsCount: slotsPerSide,
                verticalGap: spacing,
                horizontalGap: spacing,
                childCount: slotsCount,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= previewWidgetList.length) {
                    return const SizedBox.expand();
                  }

                  return previewWidgetList[index];
                },
              ),
            ),
          ),
        );
      },
    );
  }

  int _calcSlotsPerSide(int itemsCount) {
    if (itemsCount <= 1) {
      return 1;
    } else if (itemsCount <= 4) {
      return 2;
    } else {
      return 3;
    }
  }
}
