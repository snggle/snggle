import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool valueBool;
  final ValueChanged<bool>? valueChanged;
  final double height;
  final String? semanticLabel;

  const CustomSwitch({
    required this.valueBool,
    required this.valueChanged,
    this.height = 28,
    this.semanticLabel,
    super.key,
  });

  @override
  Widget build(BuildContext buildContext) {
    const Duration animationDuration = Duration(milliseconds: 200);
    const Color greyColor = Color(0xFF969696);
    final bool disabledBool = valueChanged == null;
    final double scale = height / 28;

    return Semantics(
      label: semanticLabel,
      toggled: valueBool,
      enabled: !disabledBool,
      child: InkWell(
        onTap: disabledBool ? null : () => valueChanged?.call(!valueBool),
        splashFactory: NoSplash.splashFactory,
        customBorder: const StadiumBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: kMinInteractiveDimension, minHeight: kMinInteractiveDimension),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Opacity(
              opacity: disabledBool ? 0.5 : 1,
              child: AnimatedContainer(
                duration: animationDuration,
                curve: Curves.easeInOut,
                width: 52 * scale,
                height: height,
                padding: EdgeInsets.all(scale),
                alignment: valueBool ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height / 2),
                  border: Border.all(color: valueBool ? Colors.transparent : greyColor, width: 1.5 * scale),
                  gradient: RadialGradient(
                    center: const Alignment(0.8, -0.8),
                    radius: 1.6,
                    colors: valueBool ? const <Color>[Color(0xFF42D2FF), Color(0xFF378097)] : const <Color>[Colors.white, Colors.white],
                  ),
                ),
                child: AnimatedContainer(
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                  width: 22 * scale,
                  height: 22 * scale,
                  decoration: BoxDecoration(color: valueBool ? Colors.white : greyColor, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
