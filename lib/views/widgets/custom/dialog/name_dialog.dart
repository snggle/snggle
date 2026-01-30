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
  final List<String>? existingNamesList;

  const NameDialog({
    required this.title,
    this.defaultName,
    this.description,
    this.onClose,
    this.onSave,
    this.existingNamesList,
    super.key,
  });

  @override
  NameDialogState createState() => NameDialogState();
}

class NameDialogState extends State<NameDialog> {
  final TextEditingController textEditingController = TextEditingController();
  bool _nameTakenBool = false;
  bool _nameIsEmptyBool = false;

  @override
  void initState() {
    super.initState();
    if (widget.defaultName != null) {
      textEditingController.text = widget.defaultName!;
    }
    textEditingController.addListener(_handleNameChanged);
    _handleNameChanged();
  }

  @override
  void dispose() {
    textEditingController
      ..removeListener(_handleNameChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    bool inputIsEmptyBool = textEditingController.text.trim().isEmpty;
    bool saveButtonEnabledBool = widget.onSave != null && inputIsEmptyBool == false;

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
            if (_nameTakenBool == true)
              const ErrorMessageListTile(
                message: 'Folder with this name already exists',
              ),
            if (inputIsEmptyBool == true)
              const ErrorMessageListTile(
                message: 'Folder name cannot be empty',
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

  void _handleNameChanged() {
    String name = textEditingController.text;
    bool nameTakenBool = widget.existingNamesList?.any((String existingName) => existingName == name) ?? false;

    bool nameIsEmptyBool = name.isEmpty;

    if (nameTakenBool != _nameTakenBool || nameIsEmptyBool != _nameIsEmptyBool) {
      setState(() {
        _nameTakenBool = nameTakenBool;
        _nameIsEmptyBool = nameIsEmptyBool;
      });
    }
  }

  void _saveName() {
    String newName = textEditingController.text;
    widget.onSave!(newName);
  }
}
