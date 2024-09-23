import 'package:flutter/material.dart';

class QRAreaPainter extends CustomPainter {
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double horizontalPadding;

  const QRAreaPainter({
    this.borderWidth = 5,
    this.borderRadius = 8,
    this.borderLength = 15,
    this.horizontalPadding = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Rect centeredRect = Offset.zero & size;
    Rect paddedRect = Rect.fromLTRB(
      centeredRect.left + horizontalPadding,
      centeredRect.top + horizontalPadding,
      centeredRect.right - horizontalPadding,
      centeredRect.bottom - horizontalPadding,
    );

    Paint boxPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    RRect topRightCorner = RRect.fromLTRBAndCorners(
      paddedRect.right - borderLength,
      paddedRect.top,
      paddedRect.right,
      paddedRect.top + borderLength,
      topRight: Radius.circular(borderRadius),
    );

    RRect topLeftCorner = RRect.fromLTRBAndCorners(
      paddedRect.left,
      paddedRect.top,
      paddedRect.left + borderLength,
      paddedRect.top + borderLength,
      topLeft: Radius.circular(borderRadius),
    );

    RRect bottomRightCorner = RRect.fromLTRBAndCorners(
      paddedRect.right - borderLength,
      paddedRect.bottom - borderLength,
      paddedRect.right,
      paddedRect.bottom,
      bottomRight: Radius.circular(borderRadius),
    );

    RRect bottomLeftCorner = RRect.fromLTRBAndCorners(
      paddedRect.left,
      paddedRect.bottom - borderLength,
      paddedRect.left + borderLength,
      paddedRect.bottom,
      bottomLeft: Radius.circular(borderRadius),
    );

    canvas
      ..saveLayer(centeredRect, Paint())
      ..drawRRect(topRightCorner, _getBorderPaint(topRightCorner, Alignment.topRight))
      ..drawRRect(topLeftCorner, _getBorderPaint(topLeftCorner, Alignment.topLeft))
      ..drawRRect(bottomRightCorner, _getBorderPaint(bottomRightCorner, Alignment.bottomRight))
      ..drawRRect(bottomLeftCorner, _getBorderPaint(bottomLeftCorner, Alignment.bottomLeft))
      ..drawRRect(
        RRect.fromRectAndRadius(paddedRect, Radius.circular(borderRadius)),
        boxPaint,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Paint _getBorderPaint(RRect rRect, Alignment alignment) {
    Gradient gradient = RadialGradient(
      center: alignment,
      radius: 1.4,
      colors: const <Color>[
        Color(0xFF42D2FF),
        Color(0xFF939393),
      ],
    );

    return Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(rRect.left, rRect.top, rRect.height, rRect.width))
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
  }
}
