import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_chunks_list/abi_chunks_list.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_display_mode_config_dialog.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_display_mode_type.dart';
import 'package:snggle/views/widgets/generic/display_mode/diaplay_mode_layout.dart';
import 'package:snggle/views/widgets/generic/hex_text.dart';

class AbiDisplayModeSelector extends StatefulWidget {
  final String label;
  final Uint8List functionBytes;
  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;

  const AbiDisplayModeSelector({
    required this.label,
    required this.functionBytes,
    this.textStyle,
    this.labelTextStyle,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AbiDisplayModeSelectorState();
}

class _AbiDisplayModeSelectorState extends State<AbiDisplayModeSelector> {
  AbiDisplayModeType abiDisplayModeType = AbiDisplayModeType.hex;

  @override
  Widget build(BuildContext context) {
    return DisplayModeLayout(
      label: widget.label,
      labelTextStyle: widget.labelTextStyle,
      onShowDialogPressed: _showOptionsDialog,
      child: switch (abiDisplayModeType) {
        AbiDisplayModeType.abi => AbiChunksList(functionBytes: widget.functionBytes, textStyle: widget.textStyle),
        AbiDisplayModeType.hex => HexText(bytes: widget.functionBytes, textStyle: widget.textStyle),
      },
    );
  }

  Future<void> _showOptionsDialog() async {
    AbiDisplayModeType? abiDisplayModeType = await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AbiDisplayModeConfigDialog(abiDisplayModeType: this.abiDisplayModeType);
      },
    );

    if (abiDisplayModeType != null) {
      setState(() => this.abiDisplayModeType = abiDisplayModeType);
    }
  }
}
