import 'package:flutter/material.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/views/widgets/generic/sliver_grid_delegate_with_max_spacing_extend.dart';

class SliverPageGrid extends StatelessWidget {
  static const int _loadingItemsCount = 24;

  final Size listItemSize;
  final bool addButtonVisibleBool;
  final bool loadingBool;
  final Widget loadingPlaceholder;
  final Widget vaultCreationButton;
  final Widget Function(AListItemModel listItemModel) itemBuilder;
  final List<AListItemModel> items;
  final List<AListItemModel> selectedItems;

  const SliverPageGrid({
    required this.listItemSize,
    required this.addButtonVisibleBool,
    required this.loadingBool,
    required this.loadingPlaceholder,
    required this.vaultCreationButton,
    required this.itemBuilder,
    required this.items,
    required this.selectedItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithMaxSpacingExtend(
          minimalHorizontalSpacing: 10,
          minimalVerticalSpacing: 1,
          itemSize: listItemSize,
        ),
        itemCount: loadingBool ? _loadingItemsCount : (items.length + (addButtonVisibleBool ? 1 : 0)),
        itemBuilder: (BuildContext context, int index) {
          if (loadingBool) {
            return loadingPlaceholder;
          }

          bool buttonItemBool = index == items.length;
          if (buttonItemBool) {
            return vaultCreationButton;
          }

          AListItemModel listItemModel = items[index];
          return itemBuilder.call(listItemModel);
        },
      ),
    );
  }
}
