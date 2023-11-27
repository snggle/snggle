import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class PinpadDot extends StatefulWidget {
  static const double height = 90;
  final bool errorBool;
  final int? number;

  const PinpadDot({
    required this.errorBool,
    this.number,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PinpadDotState();
}

class _PinpadDotState extends State<PinpadDot> {
  bool obscureNumberBool = true;

  @override
  void didUpdateWidget(covariant PinpadDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.number != oldWidget.number) {
      obscureNumberBool = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    late Widget child;

    if (obscureNumberBool) {
      child = Opacity(
        opacity: widget.number != null ? 1 : 0.22,
        child: Center(
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) {
              return RadialGradient(
                radius: 1,
                center: const Alignment(0.6, -0.6),
                colors: widget.errorBool ? AppColors.validationGradient.colors : AppColors.primaryGradient.colors,
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              );
            },
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1)),
            ),
          ),
        ),
      );
    } else {
      child = Center(
        child: Text(
          '${widget.number}',
          style: TextStyle(
            color: AppColors.body1,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _toggleObscureNumber,
      child: Container(
        color: Colors.transparent,
        height: PinpadDot.height,
        child: child,
      ),
    );
  }

  void _toggleObscureNumber() {
    if (widget.number != null) {
      setState(() => obscureNumberBool = !obscureNumberBool);
    }
  }
}
