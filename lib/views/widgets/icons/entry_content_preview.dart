import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_preview_item_type.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class EntryContentPreview extends StatelessWidget {
  final EntryPreviewItemType previewItemType;

  const EntryContentPreview({
    required this.previewItemType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
