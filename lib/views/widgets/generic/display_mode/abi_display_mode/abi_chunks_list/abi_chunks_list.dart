import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snggle/shared/utils/abi_utils.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_chunks_list/abi_chunks_list_item.dart';
import 'package:snggle/views/widgets/generic/display_mode/display_mode_line_number_wrapper.dart';

class AbiChunksList extends StatelessWidget {
  final Uint8List functionBytes;
  final TextStyle? textStyle;

  const AbiChunksList({
    required this.functionBytes,
    required this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Uint8List> abiChunks = _calcFunctionDataChunks();
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
          child: AbiChunksListItem(lastChunkBool: index == totalLinesLength - 1, value: chunk, textStyle: textStyle),
        );
      },
    );
  }

  List<Uint8List> _calcFunctionDataChunks() {
    List<Uint8List> abiChunks = <Uint8List>[];
    for (int start = 0; start < functionBytes.length; start += AbiUtils.abiChunkSize) {
      int end = start + AbiUtils.abiChunkSize;
      if (end > functionBytes.length) {
        end = functionBytes.length;
      }
      abiChunks.add(functionBytes.sublist(start, end));
    }
    return abiChunks;
  }
}
