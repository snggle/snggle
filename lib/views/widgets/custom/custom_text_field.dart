import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/gradient_underline_input_border.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool autofocusBool;
  final bool enableInteractiveSelection;
  final bool errorExistsBool;
  final bool readOnlyBool;
  final bool obscureTextBool;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final ValueChanged<bool>? onFocusChanged;
  final TextEditingController? textEditingController;

  const CustomTextField({
    required this.label,
    this.autofocusBool = false,
    this.enableInteractiveSelection = false,
    this.errorExistsBool = false,
    this.readOnlyBool = false,
    this.obscureTextBool = false,
    this.initialValue,
    this.focusNode,
    this.onFocusChanged,
    this.keyboardType = TextInputType.none,
    this.textEditingController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_handleFocusChanged);
    if (widget.initialValue != null) {
      widget.textEditingController?.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.focusNode?.requestFocus(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.darkGrey,
              ),
            ),
            TextFormField(
              readOnly: widget.readOnlyBool,
              obscureText: widget.obscureTextBool,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              enableSuggestions: false,
              autocorrect: false,
              controller: widget.textEditingController,
              focusNode: widget.focusNode,
              autofocus: widget.autofocusBool,
              keyboardType: widget.keyboardType,
              cursorColor: AppColors.body1,
              cursorWidth: 1.5,
              obscuringCharacter: '*',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.body3,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                enabledBorder: widget.errorExistsBool
                    ? GradientUnderlineInputBorder(gradient: AppColors.validationGradient)
                    : UnderlineInputBorder(borderSide: BorderSide(color: AppColors.middleGrey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.middleGrey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFocusChanged() {
    widget.onFocusChanged?.call(widget.focusNode!.hasFocus);
  }
}
