import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/dialog_checkbox_tile.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_config.dart';
import 'package:snggle/views/widgets/generic/display_mode/text_display_mode/text_display_mode_type.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class TextDisplayModeConfigDialog extends StatefulWidget {
  final TextDisplayModeConfig textDisplayModeConfig;

  const TextDisplayModeConfigDialog({
    required this.textDisplayModeConfig,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TextDisplayModeConfigDialogState();
}

class _TextDisplayModeConfigDialogState extends State<TextDisplayModeConfigDialog> {
  late TextDisplayModeConfig textDisplayModeConfig = widget.textDisplayModeConfig;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Display mode',
      backgroundColor: AppColors.body2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LabelWrapperVertical.dialog(
            label: 'Line Number',
            labelGap: 10,
            child: Column(
              children: <Widget>[
                DialogCheckboxTile(
                  enabledBool: _isTextSelected,
                  selectedBool: textDisplayModeConfig.lineNumbersEnabledBool,
                  title: 'Line Number',
                  onTap: () {
                    _updateTextDisplayModeConfig(textDisplayModeConfig.copyWith(
                      lineNumbersEnabledBool: textDisplayModeConfig.lineNumbersEnabledBool == false,
                    ));
                  },
                ),
              ],
            ),
          ),
          LabelWrapperVertical.dialog(
            label: 'Invisible Characters',
            labelGap: 10,
            child: Column(
              children: <Widget>[
                DialogCheckboxTile(
                  enabledBool: _isTextSelected,
                  selectedBool: textDisplayModeConfig.newLinesEnabledBool,
                  title: 'Newlines',
                  onTap: () {
                    _updateTextDisplayModeConfig(textDisplayModeConfig.copyWith(
                      newLinesEnabledBool: textDisplayModeConfig.newLinesEnabledBool == false,
                    ));
                  },
                ),
                DialogCheckboxTile(
                  enabledBool: _isTextSelected,
                  selectedBool: textDisplayModeConfig.tabsEnabledBool,
                  title: 'Tabs',
                  onTap: () {
                    _updateTextDisplayModeConfig(textDisplayModeConfig.copyWith(
                      tabsEnabledBool: textDisplayModeConfig.tabsEnabledBool == false,
                    ));
                  },
                ),
                DialogCheckboxTile(
                  enabledBool: _isTextSelected,
                  selectedBool: textDisplayModeConfig.spacesEnabledBool,
                  title: 'Spaces',
                  onTap: () {
                    _updateTextDisplayModeConfig(textDisplayModeConfig.copyWith(
                      spacesEnabledBool: textDisplayModeConfig.spacesEnabledBool == false,
                    ));
                  },
                ),
              ],
            ),
          ),
          LabelWrapperVertical.dialog(
            label: 'Format',
            labelGap: 10,
            bottomBorderVisibleBool: false,
            child: Column(
              children: <Widget>[
                DialogCheckboxTile(
                  selectedBool: _isTextSelected,
                  title: 'Text',
                  onTap: () => _setTextDisplayMode(TextDisplayModeType.text),
                ),
                DialogCheckboxTile(
                  selectedBool: _isHexSelected,
                  title: 'Hex',
                  onTap: () => _setTextDisplayMode(TextDisplayModeType.hex),
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
            Navigator.of(context).pop(textDisplayModeConfig);
          },
        ),
      ],
    );
  }

  bool get _isTextSelected => textDisplayModeConfig.textDisplayModeType == TextDisplayModeType.text;

  bool get _isHexSelected => textDisplayModeConfig.textDisplayModeType == TextDisplayModeType.hex;

  void _setTextDisplayMode(TextDisplayModeType textDisplayModeType) {
    _updateTextDisplayModeConfig(TextDisplayModeConfig(textDisplayModeType: textDisplayModeType));
  }

  void _updateTextDisplayModeConfig(TextDisplayModeConfig textDisplayModeConfig) {
    this.textDisplayModeConfig = textDisplayModeConfig;
    setState(() {});
  }
}
