import 'dart:ui';

import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';

class WalletIcon extends StatelessWidget {
  final double size;
  final WalletModel walletModel;

  const WalletIcon({
    required this.size,
    required this.walletModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = SvgPicture.string(
      Blockies(seed: walletModel.address).toSvg(size: 13),
      fit: BoxFit.cover,
      width: size,
      height: size,
    );

    Widget backdropFilterWidget = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      ),
    );

    if (walletModel.pinnedBool) {
      double radius = size * 0.565217391;
      BorderRadius borderRadius = BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );

      iconWidget = ClipRRect(borderRadius: borderRadius, child: iconWidget);

      backdropFilterWidget = ClipRRect(borderRadius: borderRadius, child: backdropFilterWidget);
    } else {
      iconWidget = ClipOval(child: iconWidget);
      backdropFilterWidget = ClipOval(child: backdropFilterWidget);
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: <Widget>[
          iconWidget,
          if (walletModel.encryptedBool) backdropFilterWidget,
          if (walletModel.encryptedBool)
            Center(
              child: GradientIcon(
                AppIcons.lock,
                size: size * 0.5,
                gradient: AppColors.primaryGradient,
              ),
            ),
        ],
      ),
    );
  }
}
