import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/icons/list_item_icon.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_type.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout_animated.dart';

class PasskeyListItem extends StatelessWidget {
  final PasskeyModel passkeyModel;
  final AnimationController fadeAnimationController;
  final AnimationController slideAnimationController;

  const PasskeyListItem({
    required this.passkeyModel,
    required this.fadeAnimationController,
    required this.slideAnimationController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return HorizontalListItemLayoutAnimated(
      lockedBool: passkeyModel.encryptedBool,
      horizontalListItemAnimationType:
      HorizontalListItemAnimationType.slideLeftToRight,
      fadeAnimationController: fadeAnimationController,
      slideAnimationController: slideAnimationController,
      iconWidget: ListItemIcon(
        size: HorizontalListItemLayout.listItemIconSize,
        listItemModel: passkeyModel,
      ),
      titleWidget: Text(
        passkeyModel.rpName.isNotEmpty
            ? passkeyModel.rpName
            : passkeyModel.rpId,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textTheme.titleMedium?.copyWith(
          color: AppColors.body1,
        ),
      ),
      subtitleWidget: GradientText(
        passkeyModel.encryptedBool
            ? ''
            : passkeyModel.userName,
        textStyle: textTheme.titleMedium,
        overflow: TextOverflow.ellipsis,
        gradient: RadialGradient(
          radius: 7,
          center: const Alignment(-1, 1.5),
          colors: AppColors.primaryGradient.colors,
        ),
      ),
    );
  }
}