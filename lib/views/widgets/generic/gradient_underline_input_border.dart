import 'dart:math' as math;

import 'package:flutter/material.dart';

class GradientUnderlineInputBorder extends InputBorder {
  final Gradient gradient;
  final BorderRadius borderRadius;

  const GradientUnderlineInputBorder({
    required this.gradient,
    super.borderSide = const BorderSide(),
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(4.0),
      topRight: Radius.circular(4.0),
    ),
  });

  @override
  bool get isOutline => false;

  @override
  GradientUnderlineInputBorder copyWith({Gradient? gradient, BorderSide? borderSide, BorderRadius? borderRadius}) {
    return GradientUnderlineInputBorder(
      gradient: gradient ?? this.gradient,
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.only(bottom: borderSide.width);
  }

  @override
  GradientUnderlineInputBorder scale(double t) {
    return GradientUnderlineInputBorder(gradient: gradient, borderSide: borderSide.scale(t));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(Rect.fromLTWH(rect.left, rect.top, rect.width, math.max(0.0, rect.height - borderSide.width)));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint, {TextDirection? textDirection}) {
    Paint gradientPaint = _getPaint(rect);
    canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), gradientPaint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientUnderlineInputBorder) {
      return GradientUnderlineInputBorder(
        gradient: gradient,
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientUnderlineInputBorder) {
      return GradientUnderlineInputBorder(
        gradient: gradient,
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    Paint paint = _getPaint(rect);
    if (borderRadius.bottomLeft != Radius.zero || borderRadius.bottomRight != Radius.zero) {
      canvas.clipPath(getOuterPath(rect, textDirection: textDirection));
    }
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, paint);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GradientUnderlineInputBorder && other.borderSide == borderSide && other.borderRadius == borderRadius;
  }

  Paint _getPaint(Rect rect) {
    return Paint()
      ..strokeWidth = borderSide.width
      ..shader = LinearGradient(
        colors: gradient.colors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke;
  }

  @override
  int get hashCode => Object.hash(borderSide, borderRadius);
}
