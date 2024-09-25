import 'package:flutter/cupertino.dart';

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final TextOverflow? overflow;

  const GradientText(
    this.text, {
    required this.gradient,
    this.maxLines,
    this.textAlign,
    this.textStyle,
    this.overflow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: gradient.createShader,
      child: Text(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflow,
        style: textStyle,
      ),
    );
  }
}
