import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';

class SliverPageList extends StatelessWidget {
  static const int _loadingItemsCount = 24;

  final bool loadingBool;
  final Widget loadingPlaceholder;
  final Widget Function(AListItemModel listItemModel) itemBuilder;
  final List<AListItemModel> items;
  final List<AListItemModel> selectedItems;
  final bool addButtonVisibleBool;
  final Widget? creationButton;

  const SliverPageList({
    required this.loadingBool,
    required this.loadingPlaceholder,
    required this.itemBuilder,
    required this.items,
    required this.selectedItems,
    this.addButtonVisibleBool = true,
    this.creationButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int itemsCount = loadingBool ? _loadingItemsCount : items.length;
    if (addButtonVisibleBool && creationButton != null) {
      itemsCount += 1;
    }

    return SliverPadding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      sliver: SliverList.builder(
        itemCount: itemsCount,
        itemBuilder: (BuildContext context, int index) {
          if (loadingBool) {
            return loadingPlaceholder;
          }

          bool buttonItemBool = index == items.length;
          if (buttonItemBool) {
            return creationButton;
          }

          AListItemModel listItemModel = items[index];
          return itemBuilder.call(listItemModel);
        },
      ),
    );
  }
}
