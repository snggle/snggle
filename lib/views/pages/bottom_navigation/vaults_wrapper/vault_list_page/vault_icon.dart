import 'dart:ui';

import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';

class VaultIcon extends StatelessWidget {
  final bool lockedBool;
  final bool pinnedBool;
  final List<WalletModel> wallets;

  const VaultIcon({
    required this.lockedBool,
    required this.pinnedBool,
    required this.wallets,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius itemRadius = pinnedBool
        ? const BorderRadius.only(
            topRight: Radius.circular(26),
            bottomLeft: Radius.circular(26),
            bottomRight: Radius.circular(26),
          )
        : BorderRadius.circular(26);

    Widget walletsGridWidget = Padding(
      padding: const EdgeInsets.all(11),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        children: wallets.map(
          (WalletModel e) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(4.5),
              child: SvgPicture.string(
                Blockies(seed: e.address).toSvg(size: 13),
              ),
            );
          },
        ).toList(),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        walletsGridWidget,
        if (lockedBool)
          ClipRRect(
            borderRadius: itemRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            border: pinnedBool ? GradientBoxBorder(gradient: AppColors.primaryGradient) : Border.all(color: AppColors.middleGrey),
            borderRadius: itemRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (lockedBool)
                GradientIcon(
                  AppIcons.lock,
                  size: 42,
                  gradient: AppColors.primaryGradient,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
