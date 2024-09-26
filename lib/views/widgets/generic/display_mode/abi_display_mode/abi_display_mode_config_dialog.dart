import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/custom/dialog/dialog_checkbox_tile.dart';
import 'package:snggle/views/widgets/generic/display_mode/abi_display_mode/abi_display_mode_type.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class AbiDisplayModeConfigDialog extends StatefulWidget {
  final AbiDisplayModeType abiDisplayModeType;

  const AbiDisplayModeConfigDialog({
    required this.abiDisplayModeType,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AbiDisplayModeConfigDialogState();
}

class _AbiDisplayModeConfigDialogState extends State<AbiDisplayModeConfigDialog> {
  late AbiDisplayModeType abiDisplayModeType;

  @override
  void initState() {
    super.initState();
    abiDisplayModeType = widget.abiDisplayModeType;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Display mode',
      backgroundColor: AppColors.body2,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LabelWrapperVertical.dialog(
            label: 'Format',
            labelGap: 10,
            bottomBorderVisibleBool: false,
            child: Column(
              children: <Widget>[
                DialogCheckboxTile(
                  selectedBool: abiDisplayModeType == AbiDisplayModeType.abi,
                  title: 'ABI',
                  onTap: () => setState(() => abiDisplayModeType = AbiDisplayModeType.abi),
                ),
                DialogCheckboxTile(
                  selectedBool: abiDisplayModeType == AbiDisplayModeType.hex,
                  title: 'Hex',
                  onTap: () => setState(() => abiDisplayModeType = AbiDisplayModeType.hex),
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
            Navigator.of(context).pop(abiDisplayModeType);
          },
        ),
      ],
    );
  }
}
