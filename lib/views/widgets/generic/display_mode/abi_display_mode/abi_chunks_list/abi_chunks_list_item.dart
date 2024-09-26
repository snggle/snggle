import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/abi_chunk_type.dart';
import 'package:snggle/shared/utils/abi_utils.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
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
  late AbiChunkType abiChunkType;

  @override
  void initState() {
    super.initState();
    abiChunkType = AbiUtils.recognizeChunkType(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String value = switch (abiChunkType) {
      AbiChunkType.hex => HexCodec.encode(widget.value, includePrefixBool: true),
      AbiChunkType.text => AbiUtils.parseChunkToString(widget.value) ?? '',
      AbiChunkType.number => AbiUtils.parseChunkToNumber(widget.value),
      AbiChunkType.address => AbiUtils.parseChunkToAddress(widget.value) ?? '',
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
                switch (abiChunkType) {
                  AbiChunkType.hex => 'Hex',
                  AbiChunkType.text => 'Text',
                  AbiChunkType.number => 'Number',
                  AbiChunkType.address => 'Address',
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
    AbiChunkType? selectedAbiChunkType = await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AbiChunksListItemTypeDialog(
          chunkBytes: widget.value,
          abiChunkType: abiChunkType,
        );
      },
    );

    if (selectedAbiChunkType != null) {
      setState(() => abiChunkType = selectedAbiChunkType);
    }
  }
}
