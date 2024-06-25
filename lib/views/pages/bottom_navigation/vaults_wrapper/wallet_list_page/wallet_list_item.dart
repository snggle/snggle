import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/icons/list_item_icon.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_animation_type.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout.dart';
import 'package:snggle/views/widgets/list/horizontal_list_item/horizontal_list_item_layout_animated.dart';

class WalletListItem extends StatelessWidget {
  final WalletModel walletModel;
  final AnimationController fadeAnimationController;
  final AnimationController slideAnimationController;

  const WalletListItem({
    required this.walletModel,
    required this.fadeAnimationController,
    required this.slideAnimationController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return HorizontalListItemLayoutAnimated(
      lockedBool: walletModel.encryptedBool,
      horizontalListItemAnimationType: HorizontalListItemAnimationType.slideLeftToRight,
      fadeAnimationController: fadeAnimationController,
      slideAnimationController: slideAnimationController,
      iconWidget: ListItemIcon(
        size: HorizontalListItemLayout.listItemIconSize,
        listItemModel: walletModel,
      ),
      titleWidget: Text(
        walletModel.name,
        style: textTheme.titleMedium?.copyWith(color: AppColors.body1),
      ),
      subtitleWidget: Row(
        children: <Widget>[
          GradientText(
            walletModel.getShortAddress(4),
            textStyle: textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
            gradient: RadialGradient(
              radius: 7,
              center: const Alignment(-1, 1.5),
              colors: AppColors.primaryGradient.colors,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                walletModel.derivationPath,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(color: AppColors.darkGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
