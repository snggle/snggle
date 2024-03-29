import 'dart:ui';

import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';

class WalletIcon extends StatelessWidget {
  final bool lockedBool;
  final bool pinnedBool;
  final String address;

  const WalletIcon({
    required this.lockedBool,
    required this.pinnedBool,
    required this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = SvgPicture.string(
      Blockies(seed: address).toSvg(size: 13),
      fit: BoxFit.cover,
    );

    Widget backdropFilterWidget = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      ),
    );

    if (pinnedBool) {
      BorderRadius borderRadius = const BorderRadius.only(
        topRight: Radius.circular(96),
        bottomLeft: Radius.circular(96),
        bottomRight: Radius.circular(96),
      );

      iconWidget = ClipRRect(borderRadius: borderRadius, child: iconWidget);

      backdropFilterWidget = ClipRRect(borderRadius: borderRadius, child: backdropFilterWidget);
    } else {
      iconWidget = ClipOval(child: iconWidget);
      backdropFilterWidget = ClipOval(child: backdropFilterWidget);
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        iconWidget,
        if (lockedBool) backdropFilterWidget,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (lockedBool)
              GradientIcon(
                AppIcons.lock,
                size: 27,
                gradient: AppColors.primaryGradient,
              ),
          ],
        ),
      ],
    );
  }
}
