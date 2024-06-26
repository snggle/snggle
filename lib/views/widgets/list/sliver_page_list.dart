import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';

class SliverPageList extends StatelessWidget {
  static const int _loadingItemsCount = 24;

  final bool addButtonVisibleBool;
  final bool loadingBool;
  final Widget loadingPlaceholder;
  final Widget creationButton;
  final Widget Function(AListItemModel listItemModel) itemBuilder;
  final List<AListItemModel> items;
  final List<AListItemModel> selectedItems;

  const SliverPageList({
    required this.addButtonVisibleBool,
    required this.loadingBool,
    required this.loadingPlaceholder,
    required this.creationButton,
    required this.itemBuilder,
    required this.items,
    required this.selectedItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      sliver: SliverList.builder(
        itemCount: loadingBool ? _loadingItemsCount : (items.length + (addButtonVisibleBool ? 1 : 0)),
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
