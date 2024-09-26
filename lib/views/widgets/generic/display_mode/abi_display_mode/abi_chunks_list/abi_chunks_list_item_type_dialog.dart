import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/utils/abi_utils.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/dialog_checkbox_tile.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_chunks_list/abi_chunks_list_item_type.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class AbiChunksListItemTypeDialog extends StatefulWidget {
  final Uint8List chunkBytes;
  final AbiChunksListItemType abiChunksListItemType;

  const AbiChunksListItemTypeDialog({
    required this.chunkBytes,
    required this.abiChunksListItemType,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AbiChunksListItemTypeDialogState();
}

class _AbiChunksListItemTypeDialogState extends State<AbiChunksListItemTypeDialog> {
  late AbiChunksListItemType abiChunksListItemType;

  @override
  void initState() {
    super.initState();
    abiChunksListItemType = widget.abiChunksListItemType;
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
                  enabledBool: AbiUtils.parseChunkToAddress(widget.chunkBytes) != null,
                  selectedBool: abiChunksListItemType == AbiChunksListItemType.address,
                  title: 'Address',
                  onTap: () => setState(() => abiChunksListItemType = AbiChunksListItemType.address),
                ),
                DialogCheckboxTile(
                  selectedBool: abiChunksListItemType == AbiChunksListItemType.hex,
                  title: 'HEX',
                  onTap: () => setState(() => abiChunksListItemType = AbiChunksListItemType.hex),
                ),
                DialogCheckboxTile(
                  selectedBool: abiChunksListItemType == AbiChunksListItemType.number,
                  title: 'Number',
                  onTap: () => setState(() => abiChunksListItemType = AbiChunksListItemType.number),
                ),
                DialogCheckboxTile(
                  enabledBool: AbiUtils.parseChunkToString(widget.chunkBytes) != null,
                  selectedBool: abiChunksListItemType == AbiChunksListItemType.text,
                  title: 'Text',
                  onTap: () => setState(() => abiChunksListItemType = AbiChunksListItemType.text),
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
