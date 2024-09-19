import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final bool enabledBool;
  final bool autofocusBool;
  final bool customKeyboardBool;
  final bool enableInteractiveSelectionBool;
  final bool errorExistsBool;
  final bool readOnlyBool;
  final bool obscureTextBool;
  final String? initialValue;
  final String? prefixText;
  final TextStyle? textStyle;
  final TextStyle? prefixStyle;
  final Widget? prefix;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChanged;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextEditingController? textEditingController;
  final InputBorder? inputBorder;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? padding;

  const CustomTextField({
    this.enabledBool = true,
    this.autofocusBool = false,
    this.customKeyboardBool = false,
    this.enableInteractiveSelectionBool = false,
    this.errorExistsBool = false,
    this.readOnlyBool = false,
    this.obscureTextBool = false,
    this.initialValue,
    this.prefixText,
    this.textStyle,
    this.prefixStyle,
    this.prefix,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.onChanged,
    this.onFocusChanged,
    this.focusNode,
    this.keyboardType = TextInputType.none,
    this.textEditingController,
    this.inputBorder,
    this.inputFormatters,
    this.padding,
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
    ThemeData theme = Theme.of(context);

    Paint errorPainter = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: <Color>[
          Color(0xFF939393),
          Color(0xFFFF5050),
        ],
      ).createShader(Rect.fromLTWH(0, 0, (widget.textEditingController?.text.length ?? 0) * 15, 70));

    TextStyle? textStyle = widget.textStyle ?? theme.textTheme.bodyMedium;
    TextStyle? prefixStyle = widget.prefixStyle ?? textStyle ?? theme.textTheme.bodyMedium;

    return TextField(
      enabled: widget.enabledBool,
      readOnly: widget.readOnlyBool,
      obscureText: widget.obscureTextBool,
      enableInteractiveSelection: widget.enableInteractiveSelectionBool,
      enableSuggestions: false,
      autocorrect: false,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      autofocus: widget.autofocusBool,
      keyboardType: widget.keyboardType,
      cursorColor: AppColors.body1,
      cursorWidth: 1.5,
      obscuringCharacter: '*',
      onChanged: widget.onChanged?.call,
      style: widget.enabledBool
          ? textStyle?.copyWith(
              color: widget.errorExistsBool ? null : AppColors.body3,
              foreground: widget.errorExistsBool ? errorPainter : null,
            )
          : textStyle?.copyWith(color: AppColors.middleGrey),
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        prefix: widget.prefix,
        prefixText: widget.prefixText,
        prefixStyle: prefixStyle?.copyWith(color: AppColors.middleGrey),
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
        contentPadding: widget.padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        enabledBorder: widget.inputBorder ?? UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider, width: 0.6)),
        focusedBorder: widget.inputBorder ?? UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider, width: 0.6)),
        disabledBorder: widget.inputBorder ?? UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider, width: 0.6)),
      ),
    );
  }

  void _handleFocusChanged() {
    widget.onFocusChanged?.call(widget.focusNode!.hasFocus);
  }
}
