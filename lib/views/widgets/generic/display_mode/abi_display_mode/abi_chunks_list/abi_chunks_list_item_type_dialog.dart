import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/abi_chunk_type.dart';
import 'package:snggle/shared/utils/abi_utils.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/dialog_checkbox_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class AbiChunksListItemTypeDialog extends StatefulWidget {
  final Uint8List chunkBytes;
  final AbiChunkType abiChunkType;

  const AbiChunksListItemTypeDialog({
    required this.chunkBytes,
    required this.abiChunkType,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AbiChunksListItemTypeDialogState();
}

class _AbiChunksListItemTypeDialogState extends State<AbiChunksListItemTypeDialog> {
  late AbiChunkType abiChunksListItemType;

  @override
  void initState() {
    super.initState();
    abiChunksListItemType = widget.abiChunkType;
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
            labelGap: 10,
            bottomBorderVisibleBool: false,
            child: Column(
              children: <Widget>[
                DialogCheckboxTile(
                  selectedBool: abiChunksListItemType == AbiChunkType.hex,
                  title: 'Hex',
                  onTap: () => setState(() => abiChunksListItemType = AbiChunkType.hex),
                ),
                DialogCheckboxTile(
                  selectedBool: abiChunksListItemType == AbiChunkType.number,
                  title: 'Number',
                  onTap: () => setState(() => abiChunksListItemType = AbiChunkType.number),
                ),
                DialogCheckboxTile(
                  enabledBool: AbiUtils.parseChunkToString(widget.chunkBytes) != null,
                  selectedBool: abiChunksListItemType == AbiChunkType.text,
                  title: 'Text',
                  onTap: () => setState(() => abiChunksListItemType = AbiChunkType.text),
                ),
                DialogCheckboxTile(
                  enabledBool: AbiUtils.parseChunkToAddress(widget.chunkBytes) != null,
                  selectedBool: abiChunksListItemType == AbiChunkType.address,
                  title: 'Address',
                  onTap: () => setState(() => abiChunksListItemType = AbiChunkType.address),
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
            Navigator.of(context).pop(abiChunksListItemType);
          },
        ),
      ],
    );
  }
}
