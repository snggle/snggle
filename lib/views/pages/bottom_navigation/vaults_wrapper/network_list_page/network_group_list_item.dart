import 'package:flutter/material.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/views/widgets/icons/list_item_icon.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_type.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout_animated.dart';

class NetworkGroupListItem extends StatelessWidget {
  final GroupModel groupModel;
  final AnimationController fadeAnimationController;
  final AnimationController slideAnimationController;

  const NetworkGroupListItem({
    required this.groupModel,
    required this.fadeAnimationController,
    required this.slideAnimationController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return HorizontalListItemLayoutAnimated(
      lockedBool: groupModel.encryptedBool,
      horizontalListItemAnimationType: HorizontalListItemAnimationType.slideBottomToUp,
      fadeAnimationController: fadeAnimationController,
      slideAnimationController: slideAnimationController,
      iconWidget: ListItemIcon(
        size: HorizontalListItemLayout.listItemIconSize,
        listItemModel: groupModel,
      ),
      titleWidget: Text(groupModel.name, style: textTheme.titleMedium),
    );
  }
}
