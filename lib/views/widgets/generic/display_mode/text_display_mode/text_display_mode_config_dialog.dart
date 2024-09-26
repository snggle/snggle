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
  late final TextDisplayModeConfig textDisplayModeConfig;

  @override
  void initState() {
    super.initState();
    textDisplayModeConfig = widget.textDisplayModeConfig.copy();
  }

  @override
  void dispose() {
    textDisplayModeConfig.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Display mode',
      backgroundColor: AppColors.body2,
      content: ListenableBuilder(
        listenable: textDisplayModeConfig,
        builder: (BuildContext context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LabelWrapperVertical.dialog(
                label: 'Line Number',
                labelGap: 6,
                child: Column(
                  children: <Widget>[
                    DialogCheckboxTile(
                      enabledBool: textDisplayModeConfig.textDisplayModeType == TextDisplayModeType.text,
                      selectedBool: textDisplayModeConfig.areLineNumbersEnabled,
                      title: 'Line Number',
                      onTap: () => textDisplayModeConfig.lineNumbersEnabled = textDisplayModeConfig.areLineNumbersEnabled == false,
                    ),
                  ],
                ),
              ),
              LabelWrapperVertical.dialog(
                label: 'Invisible Characters',
                labelGap: 6,
                child: Column(
                  children: <Widget>[
                    DialogCheckboxTile(
                      enabledBool: textDisplayModeConfig.textDisplayModeType == TextDisplayModeType.text,
                      selectedBool: textDisplayModeConfig.areNewLinesEnabled,
                      title: 'Newlines',
                      onTap: () => textDisplayModeConfig.newLinesEnabled = textDisplayModeConfig.areNewLinesEnabled == false,
                    ),
                    DialogCheckboxTile(
                      enabledBool: textDisplayModeConfig.textDisplayModeType == TextDisplayModeType.text,
                      selectedBool: textDisplayModeConfig.areTabsEnabled,
                      title: 'Tabs',
                      onTap: () => textDisplayModeConfig.tabsEnabled = textDisplayModeConfig.areTabsEnabled == false,
                    ),
                    DialogCheckboxTile(
                      enabledBool: textDisplayModeConfig.textDisplayModeType == TextDisplayModeType.text,
                      selectedBool: textDisplayModeConfig.areSpacesEnabled,
                      title: 'Spaces',
                      onTap: () => textDisplayModeConfig.spacesEnabled = textDisplayModeConfig.areSpacesEnabled == false,
                    ),
                  ],
                ),
              ),
              LabelWrapperVertical.dialog(
                label: 'Format',
                labelGap: 6,
                bottomBorderVisibleBool: false,
                child: Column(
                  children: <Widget>[
                    DialogCheckboxTile(
                      selectedBool: textDisplayModeConfig.textDisplayModeType == TextDisplayModeType.text,
                      title: 'Text',
                      onTap: () => textDisplayModeConfig.textDisplayModeType = TextDisplayModeType.text,
                    ),
                    DialogCheckboxTile(
                      selectedBool: textDisplayModeConfig.textDisplayModeType == TextDisplayModeType.hex,
                      title: 'HEX',
                      onTap: () => textDisplayModeConfig.textDisplayModeType = TextDisplayModeType.hex,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      options: <CustomDialogOption>[
        CustomDialogOption(label: 'Close', onPressed: () {}),
        CustomDialogOption(
          label: 'Save',
          autoCloseBool: false,
          onPressed: () {
            Navigator.of(context).pop(textDisplayModeConfig.copy());
          },
        ),
      ],
    );
  }
}
