import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/chunks_preview_list_item.dart';
import 'package:snggle/views/widgets/generic/display_mode/display_mode_line_number_wrapper.dart';

class AbiDisplayModeChunksPreview extends StatelessWidget {
  final Uint8List functionBytes;
  final TextStyle? textStyle;

  const AbiDisplayModeChunksPreview({
    required this.functionBytes,
    required this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Uint8List> abiChunks = <Uint8List>[];
    for (int start = 0; start < functionBytes.length; start += 32) {
      int end = start + 32;
      if (end > functionBytes.length) {
        end = functionBytes.length;
      }
      abiChunks.add(functionBytes.sublist(start, end));
    }

    int totalLinesLength = abiChunks.length;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalLinesLength,
      itemBuilder: (BuildContext context, int index) {
        Uint8List chunk = abiChunks[index];

        return DisplayModeLineNumberWrapper(
          lineNumber: index,
          totalLinesLength: abiChunks.length,
          textStyle: textStyle,
          visibleBool: true,
          child: ChunksPreviewListItem(lastChunkBool: index == totalLinesLength - 1, value: chunk, textStyle: textStyle),
        );
      },
    );
  }
}
