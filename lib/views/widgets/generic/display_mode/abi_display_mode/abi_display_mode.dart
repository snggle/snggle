import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_chunks_list/abi_chunks_list.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_display_mode_config_dialog.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_display_mode_type.dart';
import 'package:snggle/views/widgets/generic/display_mode/diaplay_mode_layout.dart';
import 'package:snggle/views/widgets/generic/display_mode/hex_display_mode/hex_display_mode.dart';

class AbiDisplayMode extends StatefulWidget {
  final String label;
  final Uint8List functionBytes;
  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;

  const AbiDisplayMode({
    required this.label,
    required this.functionBytes,
    this.textStyle,
    this.labelTextStyle,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AbiDisplayModeState();
}

class _AbiDisplayModeState extends State<AbiDisplayMode> {
  AbiDisplayModeType abiDisplayModeType = AbiDisplayModeType.hex;

  @override
  Widget build(BuildContext context) {
    return DisplayModeLayout(
      label: widget.label,
      labelTextStyle: widget.labelTextStyle,
      onShowDialogPressed: _showOptionsDialog,
      child: switch (abiDisplayModeType) {
        AbiDisplayModeType.abi => AbiChunksList(
            functionBytes: widget.functionBytes,
            textStyle: widget.textStyle,
          ),
        AbiDisplayModeType.hex => HexDisplayMode(
            bytes: widget.functionBytes,
            textStyle: widget.textStyle,
          ),
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
