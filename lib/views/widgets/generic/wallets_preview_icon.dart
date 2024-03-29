import 'dart:math';
import 'dart:ui';

import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';

class WalletsPreviewIcon extends StatelessWidget {
  final bool lockedBool;
  final bool pinnedBool;
  final List<String> walletAddresses;
  final double radius;
  final double padding;

  const WalletsPreviewIcon({
    required this.lockedBool,
    required this.pinnedBool,
    required this.walletAddresses,
    this.radius = 26,
    this.padding = 11,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double gapSize = 3;

    List<String> visibleWalletAddresses = walletAddresses.sublist(0, min(9, walletAddresses.length));

    BorderRadius itemRadius = pinnedBool
        ? BorderRadius.only(
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          )
        : BorderRadius.circular(radius);

    Widget walletsGridWidget = Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: <Widget>[
          for (int y = 0; y < 3; y++) ...<Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  for (int x = 0; x < 3; x++) ...<Widget>[
                    if (visibleWalletAddresses.length > y * 3 + x)
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.5),
                          child: SvgPicture.string(
                            Blockies(seed: visibleWalletAddresses[y * 3 + x]).toSvg(size: 13),
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    if (x < 2) SizedBox(width: gapSize),
                  ],
                ],
              ),
            ),
            if (y < 2) SizedBox(height: gapSize),
          ],
        ],
      ),
    );

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          child: walletsGridWidget,
        ),
        if (lockedBool)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: itemRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: Container(
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
                    size: padding < 11 ? 27 : 42,
                    gradient: AppColors.primaryGradient,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
