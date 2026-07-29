import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/utils/string_utils.dart';

class CustomTextField extends StatefulWidget {
  final bool _enabledBool;
  final bool _autofocusBool;
  final bool _enableInteractiveSelectionBool;
  final bool _errorExistsBool;
  final bool _readOnlyBool;
  final bool _obscureTextBool;
  final String? _initialValue;
  final String? _prefixText;
  final String? _suffixText;
  final TextStyle? _textStyle;
  final TextStyle? _prefixStyle;
  final TextStyle? _suffixStyle;
  final Widget? _prefix;
  final Widget? _suffix;
  final Widget? _prefixWidget;
  final Widget? _suffixWidget;
  final BoxConstraints? _prefixWidgetConstraints;
  final BoxConstraints? _suffixWidgetConstraints;
  final ValueChanged<String>? _onChanged;
  final ValueChanged<bool>? _onFocusChanged;
  final FocusNode? _focusNode;
  final TextInputType _keyboardType;
  final TextEditingController? _textEditingController;
  final InputBorder? _inputBorder;
  final List<TextInputFormatter>? _inputFormatters;
  final EdgeInsets? _padding;

  const CustomTextField({
    this._enabledBool = true,
    this._autofocusBool = false,
    this._enableInteractiveSelectionBool = false,
    this._errorExistsBool = false,
    this._readOnlyBool = false,
    this._obscureTextBool = false,
    this._initialValue,
    this._prefixText,
    this._suffixText,
    this._textStyle,
    this._prefixStyle,
    this._suffixStyle,
    this._prefix,
    this._suffix,
    this._prefixWidget,
    this._suffixWidget,
    this._prefixWidgetConstraints,
    this._suffixWidgetConstraints,
    this._onChanged,
    this._onFocusChanged,
    this._focusNode,
    this._keyboardType = TextInputType.none,
    this._textEditingController,
    this._inputBorder,
    this._inputFormatters,
    this._padding,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    widget._focusNode?.addListener(_handleFocusChanged);
    if (widget._initialValue != null) {
      widget._textEditingController?.text = widget._initialValue!;
    }
  }

  @override
  void dispose() {
    widget._focusNode?.removeListener(_handleFocusChanged);
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
      ).createShader(Rect.fromLTWH(0, 0, (widget._textEditingController?.text.length ?? 0) * 15, 70));

    TextStyle? textStyle = widget._textStyle ?? theme.textTheme.bodyMedium;
    TextStyle? prefixStyle = widget._prefixStyle ?? textStyle ?? theme.textTheme.bodyMedium;
    TextStyle? suffixStyle = widget._suffixStyle ?? textStyle ?? theme.textTheme.bodyMedium;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget._textEditingController!,
      builder: (BuildContext context, TextEditingValue value, _) {
        bool suffixExistsBool = widget._suffixWidget != null;
        double suffixOffset = suffixExistsBool ? _calculateSuffixOffset(value, theme, prefixStyle, textStyle, suffixStyle) : 0;

        return TextField(
          enabled: widget._enabledBool,
          readOnly: widget._readOnlyBool,
          obscureText: widget._obscureTextBool,
          enableInteractiveSelection: widget._enableInteractiveSelectionBool,
          enableSuggestions: false,
          autocorrect: false,
          maxLength: 100,
          controller: widget._textEditingController,
          focusNode: widget._focusNode,
          autofocus: widget._autofocusBool,
          keyboardType: widget._keyboardType,
          cursorColor: AppColors.body1,
          cursorWidth: 1.5,
          obscuringCharacter: '*',
          onChanged: widget._onChanged?.call,
          style: widget._enabledBool
              ? textStyle?.copyWith(
                  color: widget._errorExistsBool ? null : AppColors.body3,
                  foreground: widget._errorExistsBool ? errorPainter : null,
                )
              : textStyle?.copyWith(color: AppColors.middleGrey),
          inputFormatters: widget._inputFormatters,
          decoration: InputDecoration(
            isDense: true,
            counterText: '',
            prefix: widget._prefix,
            prefixText: widget._prefixText,
            prefixStyle: prefixStyle?.copyWith(color: AppColors.middleGrey),
            // The prefixIcon can be used as prefix text, because prefixText disappears if editable text is empty, but prefixIcon is always visible.
            prefixIcon: widget._prefixWidget,
            prefixIconConstraints: widget._prefixWidgetConstraints,
            suffix: widget._suffix,
            suffixText: widget._suffixText,
            suffixStyle: suffixStyle?.copyWith(color: AppColors.middleGrey),
            // The suffixIcon can be used as suffix text, because suffixText disappears if editable text is empty, but suffixIcon is always visible.
            suffixIcon: suffixExistsBool
                ? Transform.translate(
                    offset: Offset(suffixOffset, 0),
                    child: widget._suffixWidget,
                  )
                : widget._suffixWidget,
            suffixIconConstraints: widget._suffixWidgetConstraints ?? const BoxConstraints(minWidth: 0, minHeight: 0),
            contentPadding: widget._padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            enabledBorder: widget._inputBorder ?? UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider, width: 0.6)),
            focusedBorder: widget._inputBorder ?? UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider, width: 0.6)),
            disabledBorder: widget._inputBorder ?? UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider, width: 0.6)),
          ),
        );
      },
    );
  }

  double _calculateSuffixOffset(
    TextEditingValue textEditingValue,
    ThemeData themeData,
    TextStyle? prefixStyle,
    TextStyle? textStyle,
    TextStyle? suffixStyle,
  ) {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return 0;
    }
    double textFieldWidth = renderBox.size.width;

    double horizontalPadding = widget._padding?.horizontal ?? 12;
    double prefixIconWidth = widget._prefixWidget != null ? (widget._prefixWidgetConstraints?.maxWidth ?? 0) : 0;
    double suffixIconWidth = widget._suffixWidget != null ? (widget._suffixWidgetConstraints?.maxWidth ?? 0) : 0;

    TextScaler textScaler = MediaQuery.textScalerOf(context);
    double textEditingValueWidth = StringUtils.getTextSize(
      textEditingValue.text,
      themeData.textTheme.bodyMedium!.copyWith(color: AppColors.middleGrey),
      textScaler: textScaler,
    ).width;

    double prefixTextWidth = 0;
    if (widget._prefixText != null) {
      prefixTextWidth = StringUtils.getTextSize(widget._prefixText!, prefixStyle!, textScaler: textScaler).width;
    }
    double suffixTextWidth = StringUtils.getTextSize(widget._suffixText ?? '', suffixStyle!, textScaler: textScaler).width;

    double editableWidth = textFieldWidth - horizontalPadding - prefixIconWidth - suffixIconWidth - prefixTextWidth;
    double oneCharWidth = StringUtils.getTextSize('1', textStyle!, textScaler: textScaler).width;
    double suffixOffset = textEditingValueWidth - editableWidth + suffixTextWidth;
    double clampLowerLimit = suffixTextWidth + oneCharWidth - editableWidth;
    double clampedOffset = suffixOffset.clamp(clampLowerLimit, 0);

    return clampedOffset;
  }

  void _handleFocusChanged() {
    widget._onFocusChanged?.call(widget._focusNode!.hasFocus);
  }
}
