import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool autofocusBool;
  final bool customKeyboardBool;
  final bool enableInteractiveSelection;
  final bool errorExistsBool;
  final bool? readOnlyBool;
  final bool obscureTextBool;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final ValueChanged<bool>? onFocusChanged;
  final TextEditingController? textEditingController;

  const CustomTextField({
    required this.label,
    this.autofocusBool = false,
    this.customKeyboardBool = false,
    this.enableInteractiveSelection = false,
    this.errorExistsBool = false,
    this.readOnlyBool,
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
    Paint errorPainter = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: <Color>[
          Color(0xFF939393),
          Color(0xFFFF5050),
        ],
      ).createShader(Rect.fromLTWH(0, 0, (widget.textEditingController?.text.length ?? 0) * 15, 70));

    return Padding(
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
          TextField(
            readOnly: widget.readOnlyBool ?? widget.focusNode?.hasFocus == false,
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
              color: widget.errorExistsBool ? null : AppColors.body3,
              foreground: widget.errorExistsBool ? errorPainter : null,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.middleGrey)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.middleGrey)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFocusChanged() {
    widget.onFocusChanged?.call(widget.focusNode!.hasFocus);
  }
}
