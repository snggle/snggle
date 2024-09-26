import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/utils/abi_utils.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/dialog_checkbox_tile.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/chunks_preview_list_item_type.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class ChunksPreviewListItemTypeDialog extends StatefulWidget {
  final Uint8List chunkBytes;
  final ChunksPreviewListItemType chunksPreviewListItemType;

  const ChunksPreviewListItemTypeDialog({
    required this.chunkBytes,
    required this.chunksPreviewListItemType,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ChunksPreviewListItemTypeDialog();
}

class _ChunksPreviewListItemTypeDialog extends State<ChunksPreviewListItemTypeDialog> {
  late ChunksPreviewListItemType chunksPreviewListItemType;

  @override
  void initState() {
    super.initState();
    chunksPreviewListItemType = widget.chunksPreviewListItemType;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Display mode',
      backgroundColor: AppColors.body2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LabelWrapperVertical.dialog(
            label: 'Format',
            labelGap: 6,
            bottomBorderVisibleBool: false,
            child: Column(
              children: <Widget>[
                DialogCheckboxTile(
                  enabledBool: AbiUtils.parseChunkToAddress(widget.chunkBytes) != null,
                  selectedBool: chunksPreviewListItemType == ChunksPreviewListItemType.address,
                  title: 'Address',
                  onTap: () => setState(() => chunksPreviewListItemType = ChunksPreviewListItemType.address),
                ),
                DialogCheckboxTile(
                  selectedBool: chunksPreviewListItemType == ChunksPreviewListItemType.hex,
                  title: 'HEX',
                  onTap: () => setState(() => chunksPreviewListItemType = ChunksPreviewListItemType.hex),
                ),
                DialogCheckboxTile(
                  selectedBool: chunksPreviewListItemType == ChunksPreviewListItemType.number,
                  title: 'Number',
                  onTap: () => setState(() => chunksPreviewListItemType = ChunksPreviewListItemType.number),
                ),
                DialogCheckboxTile(
                  enabledBool: AbiUtils.parseChunkToString(widget.chunkBytes) != null,
                  selectedBool: chunksPreviewListItemType == ChunksPreviewListItemType.text,
                  title: 'Text',
                  onTap: () => setState(() => chunksPreviewListItemType = ChunksPreviewListItemType.text),
                ),
              ],
            ),
          ),
        ],
      ),
      options: <CustomDialogOption>[
        CustomDialogOption(label: 'Close', onPressed: () {}),
        CustomDialogOption(
          label: 'Save',
          autoCloseBool: false,
          onPressed: () {
            Navigator.of(context).pop(chunksPreviewListItemType);
          },
        ),
      ],
    );
  }
}
