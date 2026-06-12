import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_preview_item_type.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/icons/container_icon_grid.dart';
import 'package:snggle/views/widgets/icons/vault_container_icon.dart';

class EntryIcon extends StatelessWidget {
  final double size;
  final EntryModel entryModel;

  const EntryIcon({
    required this.size,
    required this.entryModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VaultContainerIcon(
      pinnedBool: entryModel.pinnedBool,
      encryptedBool: entryModel.encryptedBool,
      size: size,
      child: ContainerIconGrid(
        padding: EdgeInsets.all(size * 0.14),
        contentPreview: entryModel.previewItems.map(_buildContentPreview).toList(),
      ),
    );
  }

  Widget _buildContentPreview(EntryPreviewItemType previewItemType) {
    AssetIconData assetIconData = switch (previewItemType) {
      EntryPreviewItemType.email => AppIcons.icon_entry_email,
      EntryPreviewItemType.password => AppIcons.icon_entry_password,
      EntryPreviewItemType.username => AppIcons.icon_entry_username,
    };

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double iconSize = min(constraints.maxWidth, constraints.maxHeight);

        return Center(
          child: AssetIcon(
            assetIconData,
            size: iconSize,
            color: AppColors.body3,
          ),
        );
      },
    );
  }
}
