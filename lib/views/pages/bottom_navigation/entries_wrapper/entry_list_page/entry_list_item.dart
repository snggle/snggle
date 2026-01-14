import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/icons/list_item_icon.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_type.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout_animated.dart';

class EntryListItem extends StatelessWidget {
  final EntryModel entryModel;
  final AnimationController fadeAnimationController;
  final AnimationController slideAnimationController;

  const EntryListItem({
    required this.entryModel,
    required this.fadeAnimationController,
    required this.slideAnimationController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return HorizontalListItemLayoutAnimated(
      lockedBool: entryModel.encryptedBool,
      horizontalListItemAnimationType: HorizontalListItemAnimationType.slideLeftToRight,
      fadeAnimationController: fadeAnimationController,
      slideAnimationController: slideAnimationController,
      iconWidget: ListItemIcon(
        size: HorizontalListItemLayout.listItemIconSize,
        listItemModel: entryModel,
      ),
      titleWidget: Text(
        entryModel.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textTheme.titleMedium?.copyWith(color: AppColors.body1),
      ),
      subtitleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GradientText(
            entryModel.defaultItemName,
            textStyle: textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
            gradient: RadialGradient(
              radius: 7,
              center: const Alignment(-1, 1.5),
              colors: AppColors.primaryGradient.colors,
            ),
          ),
        ],
      ),
    );
  }
}
