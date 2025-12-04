import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';

class NameDialog extends StatefulWidget {
  final String title;
  final String? defaultName;
  final String? description;
  final VoidCallback? onClose;
  final ValueChanged<String>? onSave;

  const NameDialog({
    required this.title,
    this.defaultName,
    this.description,
    this.onClose,
    this.onSave,
    super.key,
  });

  @override
  NameDialogState createState() => NameDialogState();
}

class NameDialogState extends State<NameDialog> {
  final TextEditingController textEditingController = TextEditingController();
  bool _nameEmptyBool = false;

  @override
  void initState() {
    super.initState();
    if (widget.defaultName != null) {
      textEditingController.text = widget.defaultName!;
    }
    textEditingController.addListener(_updateNameEmptyState);
    _updateNameEmptyState();
  }

  @override
  void dispose() {
    textEditingController
      ..removeListener(_updateNameEmptyState)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    bool nameEmptyBool = textEditingController.text.trim().isEmpty;
    bool saveButtonEnabledBool = widget.onSave != null && nameEmptyBool == false;

    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.middleGrey),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomDialog(
        title: widget.title.toUpperCase(),
        content: Column(
          children: <Widget>[
            if (widget.description != null)
              Text(
                widget.description!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: textEditingController,
              maxLength: 100,
              autofocus: true,
              keyboardType: TextInputType.text,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.body3, height: 1),
              decoration: InputDecoration(
                isDense: true,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
              ),
            ),
            if (nameEmptyBool == true)
              const ErrorMessageListTile(
                message: 'Item name cannot be empty',
              ),
          ],
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Close',
            onPressed: widget.onClose ?? () {},
          ),
          CustomDialogOption(
            label: 'Save',
            onPressed: saveButtonEnabledBool ? _saveName : null,
          ),
        ],
      ),
    );
  }

  void _updateNameEmptyState() {
    bool tmpNameEmptyBool = textEditingController.text.trim().isEmpty;

    if (tmpNameEmptyBool != _nameEmptyBool) {
      setState(() {
        _nameEmptyBool = tmpNameEmptyBool;
      });
    }
  }

  void _saveName() {
    String newName = textEditingController.text;
    widget.onSave!(newName);
  }
}
