import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';

class VaultContainerIcon extends StatelessWidget {
  final bool pinnedBool;
  final bool encryptedBool;
  final double size;
  final Widget? child;

  const VaultContainerIcon({
    required this.pinnedBool,
    required this.encryptedBool,
    required this.size,
    this.child,
    super.key,
  });

  VaultContainerIcon.fromVaultModel({
    required VaultModel vaultModel,
    required this.size,
    this.child,
    super.key,
  })  : pinnedBool = vaultModel.pinnedBool,
        encryptedBool = vaultModel.encryptedBool;

  @override
  Widget build(BuildContext context) {
    double radius = size * 0.3125;
    late BorderRadius borderRadius;
    if (pinnedBool) {
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );
    } else {
      borderRadius = BorderRadius.circular(radius);
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(borderRadius: borderRadius, color: AppColors.body2),
            ),
          ),
          if (child != null) Positioned.fill(child: child!),
          if (encryptedBool)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
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
                borderRadius: borderRadius,
              ),
            ),
          ),
          if (encryptedBool)
            Positioned.fill(
              child: Center(
                child: GradientIcon(
                  AppIcons.lock,
                  size: size * 0.5,
                  gradient: AppColors.primaryGradient,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
