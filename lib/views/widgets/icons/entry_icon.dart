import 'package:flutter/cupertino.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_preview_item_type.dart';
import 'package:snggle/views/widgets/icons/container_icon.dart';
import 'package:snggle/views/widgets/icons/container_icon_grid.dart';
import 'package:snggle/views/widgets/icons/entry_content_preview.dart';

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
    return ContainerIcon(
      pinnedBool: entryModel.pinnedBool,
      encryptedBool: entryModel.encryptedBool,
      size: size,
      child: ContainerIconGrid.fromContentPreview(
        padding: EdgeInsets.all(size * 0.14),
        contentPreview: <Widget>[
          for (EntryPreviewItemType previewItemType in entryModel.previewItems) EntryContentPreview(previewItemType: previewItemType),
        ],
      ),
    );
  }
}
