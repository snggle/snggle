import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/utils/string_utils.dart';

class CustomTextField extends StatefulWidget {
  final bool enabledBool;
  final bool autofocusBool;
  final bool customKeyboardBool;
  final bool enableInteractiveSelectionBool;
  final bool errorExistsBool;
  final bool readOnlyBool;
  final bool obscureTextBool;
  final bool dynamicSuffixBool;
  final String? initialValue;
  final String? prefixText;
  final String? suffixText;
  final TextStyle? textStyle;
  final TextStyle? prefixStyle;
  final TextStyle? suffixStyle;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final BoxConstraints? prefixWidgetConstraints;
  final BoxConstraints? suffixWidgetConstraints;
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
    this.dynamicSuffixBool = false,
    this.initialValue,
    this.prefixText,
    this.suffixText,
    this.textStyle,
    this.prefixStyle,
    this.suffixStyle,
    this.prefix,
    this.suffix,
    this.prefixWidget,
    this.suffixWidget,
    this.prefixWidgetConstraints,
    this.suffixWidgetConstraints,
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
    TextStyle? suffixStyle = widget.suffixStyle ?? textStyle ?? theme.textTheme.bodyMedium;

    return ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.textEditingController!,
        builder: (BuildContext context, TextEditingValue value, _) {
          bool suffixExistsBool = widget.suffixWidget != null;
          double suffixOffset =
              (suffixExistsBool && widget.dynamicSuffixBool) ? _calculateSuffixOffset(value, theme, prefixStyle, textStyle, suffixStyle) : 0;

          return TextField(
            enabled: widget.enabledBool,
            readOnly: widget.readOnlyBool,
            obscureText: widget.obscureTextBool,
            enableInteractiveSelection: widget.enableInteractiveSelectionBool,
            enableSuggestions: false,
            autocorrect: false,
            maxLength: 100,
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
              counterText: '',
              prefix: widget.prefix,
              prefixText: widget.prefixText,
              prefixStyle: prefixStyle?.copyWith(color: AppColors.middleGrey),
              // The prefixIcon can be used as prefix text, because prefixText disappears if editable text is empty, but prefixIcon is always visible.
              prefixIcon: widget.prefixWidget,
              prefixIconConstraints: widget.prefixWidgetConstraints,
              suffix: widget.suffix,
              suffixText: widget.suffixText,
              suffixStyle: suffixStyle?.copyWith(color: AppColors.middleGrey),
              // The suffixIcon can be used as suffix text, because suffixText disappears if editable text is empty, but suffixIcon is always visible.
              suffixIcon: suffixExistsBool
                  ? Transform.translate(
                      offset: Offset(suffixOffset, 0),
                      child: widget.suffixWidget,
                    )
                  : widget.suffixWidget,
              suffixIconConstraints: widget.suffixWidgetConstraints ?? const BoxConstraints(minWidth: 0, minHeight: 0),
              contentPadding: widget.padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              enabledBorder: widget.inputBorder ?? UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider, width: 0.6)),
              focusedBorder: widget.inputBorder ?? UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider, width: 0.6)),
              disabledBorder: widget.inputBorder ?? UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider, width: 0.6)),
            ),
          );
        });
  }

  double _calculateSuffixOffset(
      TextEditingValue textEditingValue, ThemeData themeData, TextStyle? prefixStyle, TextStyle? textStyle, TextStyle? suffixStyle) {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return 0;
    }
    double textFieldWidth = renderBox.size.width;

    double horizontalPadding = widget.padding?.horizontal ?? 12;
    double prefixIconWidth = widget.prefixWidget != null ? (widget.prefixWidgetConstraints?.maxWidth ?? 0) : 0;
    double suffixIconWidth = widget.suffixWidget != null ? (widget.suffixWidgetConstraints?.maxWidth ?? 0) : 0;

    TextScaler textScaler = MediaQuery.textScalerOf(context);
    double textEditingValueWidth = StringUtils.getTextSize(
      textEditingValue.text,
      themeData.textTheme.bodyMedium!.copyWith(color: AppColors.middleGrey),
      textScaler: textScaler,
    ).width;

    double prefixTextWidth = 0;
    if (widget.prefixText != null) {
      prefixTextWidth = StringUtils.getTextSize(widget.prefixText!, prefixStyle!, textScaler: textScaler).width;
    }
    double suffixTextWidth = StringUtils.getTextSize(widget.suffixText ?? '', suffixStyle!, textScaler: textScaler).width;

    double editableWidth = textFieldWidth - horizontalPadding - prefixIconWidth - suffixIconWidth - prefixTextWidth;
    double oneCharWidth = StringUtils.getTextSize('1', textStyle!, textScaler: textScaler).width;
    double suffixOffset = textEditingValueWidth - editableWidth + suffixTextWidth;
    double clampLowerLimit = suffixTextWidth + oneCharWidth - editableWidth;
    double clampedOffset = suffixOffset.clamp(clampLowerLimit, 0);

    return clampedOffset;
  }

  void _handleFocusChanged() {
    widget.onFocusChanged?.call(widget.focusNode!.hasFocus);
  }
}
