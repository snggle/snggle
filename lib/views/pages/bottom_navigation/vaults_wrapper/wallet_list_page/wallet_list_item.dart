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
    String address = walletModel.address;

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
        style: textTheme.bodyMedium?.copyWith(color: AppColors.body1),
      ),
      subtitleWidget: Row(
        children: <Widget>[
          GradientText(
            '${address.substring(0, 6)}..${address.substring(address.length - 6, address.length)}',
            textStyle: textTheme.bodyMedium,
            gradient: RadialGradient(
              radius: 7,
              center: const Alignment(-1, 1.5),
              colors: AppColors.primaryGradient.colors,
            ),
          ),
          const Spacer(),
          Text(
            walletModel.derivationPath,
            style: textTheme.labelMedium?.copyWith(color: AppColors.darkGrey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
