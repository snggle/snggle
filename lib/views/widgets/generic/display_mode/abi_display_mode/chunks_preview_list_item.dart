import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/utils/abi_utils.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/chunks_preview_list_item_type.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/chunks_preview_list_item_type_dialog.dart';

class ChunksPreviewListItem extends StatefulWidget {
  final bool lastChunkBool;
  final Uint8List value;
  final TextStyle? textStyle;

  const ChunksPreviewListItem({
    required this.lastChunkBool,
    required this.value,
    required this.textStyle,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ChunksPreviewListItemState();
}

class _ChunksPreviewListItemState extends State<ChunksPreviewListItem> {
  late ChunksPreviewListItemType chunksPreviewListItemType;

  @override
  void initState() {
    super.initState();
    chunksPreviewListItemType = ChunksPreviewListItemType.fromAbiChunk(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String value = switch (chunksPreviewListItemType) {
      ChunksPreviewListItemType.hex => HexCodec.encode(widget.value, includePrefixBool: true),
      ChunksPreviewListItemType.text => String.fromCharCodes(widget.value),
      ChunksPreviewListItemType.number => AbiUtils.parseChunkToNumber(widget.value),
      ChunksPreviewListItemType.address => AbiUtils.parseChunkToAddress(widget.value) ?? '',
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
                switch (chunksPreviewListItemType) {
                  ChunksPreviewListItemType.hex => 'Hex',
                  ChunksPreviewListItemType.text => 'Text',
                  ChunksPreviewListItemType.number => 'Number',
                  ChunksPreviewListItemType.address => 'Address',
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

  Future<void> _showOptionsDialog() async {
    ChunksPreviewListItemType? chunksPreviewListItemType = await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return ChunksPreviewListItemTypeDialog(
          chunkBytes: widget.value,
          chunksPreviewListItemType: this.chunksPreviewListItemType,
        );
      },
    );

    if (chunksPreviewListItemType != null) {
      setState(() => this.chunksPreviewListItemType = chunksPreviewListItemType);
    }
  }
}
