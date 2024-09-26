import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/utils/abi_utils.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_chunks_list/abi_chunks_list_item_type.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_chunks_list/abi_chunks_list_item_type_dialog.dart';

class AbiChunksListItem extends StatefulWidget {
  final bool lastChunkBool;
  final Uint8List value;
  final TextStyle? textStyle;

  const AbiChunksListItem({
    required this.lastChunkBool,
    required this.value,
    required this.textStyle,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AbiChunksListItemState();
}

class _AbiChunksListItemState extends State<AbiChunksListItem> {
  late AbiChunksListItemType abiChunksListItemType;

  @override
  void initState() {
    super.initState();
    abiChunksListItemType = _calcInitialItemType();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String value = switch (abiChunksListItemType) {
      AbiChunksListItemType.hex => HexCodec.encode(widget.value, includePrefixBool: true),
      AbiChunksListItemType.text => String.fromCharCodes(widget.value),
      AbiChunksListItemType.number => AbiUtils.parseChunkToNumber(widget.value),
      AbiChunksListItemType.address => AbiUtils.parseChunkToAddress(widget.value) ?? '',
    };

    return CopyWrapper(
      value: value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: _showOptionsDialog,
            child: Container(
              margin: const EdgeInsets.only(top: 2, bottom: 4),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xfff3f3f3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                switch (abiChunksListItemType) {
                  AbiChunksListItemType.hex => 'Hex',
                  AbiChunksListItemType.text => 'Text',
                  AbiChunksListItemType.number => 'Number',
                  AbiChunksListItemType.address => 'Address',
                },
                style: theme.textTheme.labelMedium?.copyWith(color: AppColors.body3),
              ),
            ),
          ),
          Text(value, style: widget.textStyle),
          if (widget.lastChunkBool == false) const Divider(color: Color(0xfff3f3f3)),
        ],
      ),
    );
  }

  AbiChunksListItemType _calcInitialItemType() {
    Uint8List chunkBytes = widget.value;
    String? stringValue = AbiUtils.parseChunkToString(chunkBytes);
    if (stringValue != null) {
      return AbiChunksListItemType.text;
    }

    String? addressValue = AbiUtils.parseChunkToAddress(chunkBytes);
    if (addressValue != null && addressValue.startsWith('0x0') == false) {
      return AbiChunksListItemType.address;
    }

    return AbiChunksListItemType.hex;
  }

  Future<void> _showOptionsDialog() async {
    AbiChunksListItemType? abiChunksListItemType = await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AbiChunksListItemTypeDialog(
          chunkBytes: widget.value,
          abiChunksListItemType: this.abiChunksListItemType,
        );
      },
    );

    if (abiChunksListItemType != null) {
      setState(() => this.abiChunksListItemType = abiChunksListItemType);
    }
  }
}
