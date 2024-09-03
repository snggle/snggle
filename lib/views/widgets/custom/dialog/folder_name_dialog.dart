import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

class FolderNameDialog extends StatefulWidget {
  final VoidCallback? onClose;
  final ValueChanged<String>? onSave;

  const FolderNameDialog({
    this.onClose,
    this.onSave,
    super.key,
  });

  @override
  FolderNameDialogState createState() => FolderNameDialogState();
}

class FolderNameDialogState extends State<FolderNameDialog> {
  final String defaultName = 'New Folder';
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.middleGrey),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomDialog(
        title: 'Create new folder'.toUpperCase(),
        content: Column(
          children: <Widget>[
            Text(
              'Enter a name for the\nnew folder',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textEditingController,
              autofocus: true,
              keyboardType: TextInputType.text,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.body3, height: 1),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
                hintText: defaultName,
                hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey, height: 1),
              ),
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
            onPressed: () => widget.onSave != null ? _saveFolderName() : () {},
          ),
        ],
      ),
    );
  }

  void _saveFolderName() {
    String folderName = textEditingController.text;
    if (folderName.isEmpty) {
      folderName = defaultName;
    }
    widget.onSave!(folderName);
  }
}
