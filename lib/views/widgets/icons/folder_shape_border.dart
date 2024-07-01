import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class FolderShapeBorder extends ShapeBorder {
  final bool _pinnedBool;
  final Color _borderColor;
  final double _borderWidth;
  final double _scale;

  const FolderShapeBorder({
    required bool pinnedBool,
    required Color borderColor,
    double borderWidth = 1.0,
    double scale = 1.0,
  })  : _pinnedBool = pinnedBool,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
        _scale = scale;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    Rect innerRect = Rect.fromLTWH(rect.left + _borderWidth / 2, rect.top + _borderWidth / 2, rect.width - _borderWidth, rect.height - _borderWidth);
    return getCustomPath(innerRect.size, innerRect.topLeft);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Rect outerRect = Rect.fromLTWH(rect.left + _borderWidth / 2, rect.top + _borderWidth / 2, rect.width - _borderWidth, rect.height - _borderWidth);
    return getCustomPath(outerRect.size, outerRect.topLeft);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _borderWidth;

    if (_pinnedBool) {
      paint.shader = LinearGradient(
        colors: AppColors.primaryGradient.colors,
      ).createShader(rect);
    } else {
      paint.color = _borderColor;
    }

    Path path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return FolderShapeBorder(
      pinnedBool: _pinnedBool,
      scale: _scale * t,
      borderWidth: _borderWidth,
      borderColor: _borderColor,
    );
  }

  Path getCustomPath(Size size, Offset offset) {
    double width = size.width;
    double height = size.height;

    // Adjust the scaling based on the width and height of the container
    double scaledWidth = width / 53.320312 * _scale;
    double scaledHeight = height / 53.320312 * _scale;

    Path path = Path()
      ..moveTo(offset.dx + 7 * scaledWidth, offset.dy + 0.6796875 * scaledHeight)
      ..cubicTo(offset.dx + 3.5133528 * scaledWidth, offset.dy + 0.6796875 * scaledHeight, offset.dx + 0.6796875 * scaledWidth,
          offset.dy + 3.5133528 * scaledHeight, offset.dx + 0.6796875 * scaledWidth, offset.dy + 7 * scaledHeight)
      ..lineTo(offset.dx + 0.6796875 * scaledWidth, offset.dy + 47 * scaledHeight)
      ..cubicTo(offset.dx + 0.6796875 * scaledWidth, offset.dy + 50.486638 * scaledHeight, offset.dx + 3.5133522 * scaledWidth,
          offset.dy + 53.3203125 * scaledHeight, offset.dx + 7 * scaledWidth, offset.dy + 53.3203125 * scaledHeight)
      ..lineTo(offset.dx + 47 * scaledWidth, offset.dy + 53.3203125 * scaledHeight)
      ..cubicTo(offset.dx + 50.486638 * scaledWidth, offset.dy + 53.3203125 * scaledHeight, offset.dx + 53.320312 * scaledWidth,
          offset.dy + 50.486638 * scaledHeight, offset.dx + 53.320312 * scaledWidth, offset.dy + 47 * scaledHeight)
      ..lineTo(offset.dx + 53.320312 * scaledWidth, offset.dy + 13 * scaledHeight)
      ..cubicTo(offset.dx + 53.320312 * scaledWidth, offset.dy + 9.5133522 * scaledHeight, offset.dx + 50.486638 * scaledWidth,
          offset.dy + 6.6796875 * scaledHeight, offset.dx + 47 * scaledWidth, offset.dy + 6.6796875 * scaledHeight)
      ..lineTo(offset.dx + 26.957031 * scaledWidth, offset.dy + 6.6796875 * scaledHeight)
      ..cubicTo(offset.dx + 25.752545 * scaledWidth, offset.dy + 6.6796875 * scaledHeight, offset.dx + 24.580056 * scaledWidth,
          offset.dy + 6.2963843 * scaledHeight, offset.dx + 23.607422 * scaledWidth, offset.dy + 5.5859375 * scaledHeight)
      ..lineTo(offset.dx + 18.554687 * scaledWidth, offset.dy + 1.8964844 * scaledHeight)
      ..cubicTo(offset.dx + 17.472523 * scaledWidth, offset.dy + 1.1060327 * scaledHeight, offset.dx + 16.168142 * scaledWidth,
          offset.dy + 0.6796875 * scaledHeight, offset.dx + 14.828125 * scaledWidth, offset.dy + 0.6796875 * scaledHeight)
      ..close();
    return path;
  }
}
