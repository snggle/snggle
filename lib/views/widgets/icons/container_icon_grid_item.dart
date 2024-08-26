import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class ContainerIconGridItem extends StatelessWidget {
  final bool pinnedBool;
  final bool encryptedBool;
  final double size;
  final AssetIconData pinnedBorder;
  final AssetIconData pinnedBackground;
  final AssetIconData unpinnedBorder;
  final AssetIconData unpinnedBackground;
  final Color? backgroundColor;
  final AssetIconData? icon;

  const ContainerIconGridItem({
    required this.pinnedBool,
    required this.encryptedBool,
    required this.size,
    required this.pinnedBorder,
    required this.pinnedBackground,
    required this.unpinnedBorder,
    required this.unpinnedBackground,
    this.backgroundColor,
    this.icon,
    super.key,
  });

  ContainerIconGridItem.fromVaultModel({
    required VaultModel vaultModel,
    required this.size,
    this.backgroundColor,
    super.key,
  })  : pinnedBool = vaultModel.pinnedBool,
        encryptedBool = vaultModel.encryptedBool,
        pinnedBorder = AppIcons.icon_container_vault_pinned_medium,
        pinnedBackground = AppIcons.icon_container_vault_pinned_medium_background,
        unpinnedBorder = AppIcons.icon_container_vault_unpinned_medium,
        unpinnedBackground = AppIcons.icon_container_vault_unpinned_medium_background,
        icon = null;

  ContainerIconGridItem.fromGroupModel({
    required GroupModel groupModel,
    required this.size,
    this.backgroundColor,
    super.key,
  })  : pinnedBool = groupModel.pinnedBool,
        encryptedBool = groupModel.encryptedBool,
        pinnedBorder = AppIcons.icon_container_folder_pinned_medium,
        pinnedBackground = AppIcons.icon_container_folder_medium_background,
        unpinnedBorder = AppIcons.icon_container_folder_unpinned_medium,
        unpinnedBackground = AppIcons.icon_container_folder_medium_background,
        icon = null;

  ContainerIconGridItem.fromNetworkGroupModel({
    required NetworkGroupModel networkGroupModel,
    required this.size,
    this.backgroundColor,
    super.key,
  })  : pinnedBool = networkGroupModel.pinnedBool,
        encryptedBool = networkGroupModel.encryptedBool,
        pinnedBorder = AppIcons.icon_container_vault_pinned_medium,
        pinnedBackground = AppIcons.icon_container_vault_pinned_medium_background,
        unpinnedBorder = AppIcons.icon_container_vault_unpinned_medium,
        unpinnedBackground = AppIcons.icon_container_vault_unpinned_medium_background,
        icon = networkGroupModel.networkTemplateModel.networkIconType.listSmallIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        AssetIcon(pinnedBool ? pinnedBackground : unpinnedBackground, size: size, color: backgroundColor ?? AppColors.body2),
        AssetIcon(pinnedBool ? pinnedBorder : unpinnedBorder, size: size),
        if (encryptedBool) ...<Widget>[
          AssetIcon(AppIcons.icon_container_lock_small, size: size, color: AppColors.body3),
        ] else if (icon != null) ...<Widget>[
          AssetIcon(icon!, size: size, color: AppColors.body3),
        ]
      ],
    );
  }
}
