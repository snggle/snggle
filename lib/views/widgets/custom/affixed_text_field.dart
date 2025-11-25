import 'package:flutter/material.dart';

class AffixedTextField extends StatefulWidget {
  final String prefix;
  final String suffix;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final InputBorder? border;
  final EdgeInsets contentPadding;

  const AffixedTextField({
    required this.prefix,
    required this.suffix,
    this.controller,
    this.textStyle,
    this.border,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    super.key,
  });

  @override
  State<AffixedTextField> createState() => _AffixedTextFieldState();
}

class _AffixedTextFieldState extends State<AffixedTextField> {
  late TextEditingController _controller;
  late bool _ownController;

  @override
  void initState() {
    super.initState();
    _ownController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle style = widget.textStyle ?? theme.textTheme.bodyMedium!;
    final TextDirection textDirection = Directionality.of(context);
    final TextScaler textScaler = MediaQuery.textScalerOf(context);

    final TextPainter prefixPainter = TextPainter(
      text: TextSpan(text: widget.prefix, style: style),
      textDirection: textDirection,
      textScaler: textScaler,
    )..layout();

    final double prefixWidth = prefixPainter.width;

    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        TextField(
          controller: _controller,
          maxLines: 1,
          decoration: InputDecoration(
            isDense: true,
            border: widget.border,
            contentPadding: widget.contentPadding.copyWith(
              left: widget.contentPadding.left + prefixWidth,
            ),
          ),
          style: style,
          cursorColor: style.color,
        ),
        IgnorePointer(
          child: Padding(
            padding: widget.contentPadding,
            child: RichText(
              textDirection: textDirection,
              textScaler: textScaler,
              text: TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: widget.prefix,
                    style: style.copyWith(color: Colors.grey),
                  ),
                  TextSpan(
                    text: _controller.text,
                    style: style.copyWith(color: Colors.transparent),
                  ),
                  TextSpan(
                    text: widget.suffix,
                    style: style.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
