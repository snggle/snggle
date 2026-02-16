import 'package:flutter/cupertino.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class VaultNameForm extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool showEmptyErrorBool;

  const VaultNameForm({
    required this.textEditingController,
    required this.showEmptyErrorBool,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LabelWrapperVertical.textField(
          label: 'Name',
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          bottomBorderVisibleBool: false,
          child: CustomTextField(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            keyboardType: TextInputType.text,
            enableInteractiveSelectionBool: true,
            textEditingController: textEditingController,
          ),
        ),
        if (showEmptyErrorBool)
          const ErrorMessageListTile(
            message: 'Vault name cannot be empty',
          ),
      ],
    );
  }
}
