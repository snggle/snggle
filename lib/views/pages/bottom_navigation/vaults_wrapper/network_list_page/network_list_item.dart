import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/icons/list_item_icon.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_type.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout_animated.dart';

class NetworkListItem extends StatelessWidget {
  final NetworkGroupModel networkGroupModel;
  final AnimationController fadeAnimationController;
  final AnimationController slideAnimationController;

  const NetworkListItem({
    required this.networkGroupModel,
    required this.fadeAnimationController,
    required this.slideAnimationController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return HorizontalListItemLayoutAnimated(
      lockedBool: networkGroupModel.encryptedBool,
      horizontalListItemAnimationType: HorizontalListItemAnimationType.slideLeftToRight,
      fadeAnimationController: fadeAnimationController,
      slideAnimationController: slideAnimationController,
      iconWidget: ListItemIcon(
        size: HorizontalListItemLayout.listItemIconSize,
        listItemModel: networkGroupModel,
      ),
      titleWidget: Text(networkGroupModel.name, style: textTheme.titleMedium),
      trailingWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AssetIcon(
            networkGroupModel.networkTemplateModel.networkIconType.horizontalTileIcon,
            size: 20,
            color: AppColors.darkGrey,
          ),
          const SizedBox(height: 3),
          Padding(
            padding: EdgeInsets.only(
              right: switch (networkGroupModel.listItemsPreview.length) {
                < 10 => 6,
                < 100 => 3,
                (_) => 0,
              },
            ),
            child: Text(
              networkGroupModel.listItemsPreview.length.toString(),
              textAlign: TextAlign.end,
              style: textTheme.labelMedium?.copyWith(color: AppColors.darkGrey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
