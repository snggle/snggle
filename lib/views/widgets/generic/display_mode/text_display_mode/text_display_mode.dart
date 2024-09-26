import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/generic/display_mode/diaplay_mode_layout.dart';
import 'package:snggle/views/widgets/generic/display_mode/hex_display_mode/hex_display_mode.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_config.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_config_dialog.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_type.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_lines_list/text_lines_list.dart';

class TextDisplayMode extends StatefulWidget {
  final String label;
  final String value;
  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;

  const TextDisplayMode({
    required this.label,
    required this.value,
    required this.textStyle,
    required this.labelTextStyle,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TextDisplayModeState();
}

class _TextDisplayModeState extends State<TextDisplayMode> {
  TextDisplayModeConfig textDisplayModeConfig = TextDisplayModeConfig();

  @override
  Widget build(BuildContext context) {
    return DisplayModeLayout(
      label: widget.label,
      labelTextStyle: widget.labelTextStyle,
      onShowDialogPressed: _showOptionsDialog,
      child: switch (textDisplayModeConfig.textDisplayModeType) {
        TextDisplayModeType.text => TextLinesList(
            inputText: widget.value,
            textStyle: widget.textStyle,
            textDisplayModeConfig: textDisplayModeConfig,
          ),
        TextDisplayModeType.hex => HexDisplayMode(
            bytes: utf8.encode(widget.value),
            textStyle: widget.textStyle,
          ),
      },
    );
  }

  Future<void> _showOptionsDialog() async {
    TextDisplayModeConfig? textDisplayModeConfig = await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return TextDisplayModeConfigDialog(textDisplayModeConfig: this.textDisplayModeConfig);
      },
    );

    if (textDisplayModeConfig != null) {
      setState(() => this.textDisplayModeConfig = textDisplayModeConfig);
    }
  }
}
