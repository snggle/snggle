import 'package:flutter/material.dart';

class QRAreaClipper extends CustomClipper<Path> {
  final double horizontalPadding;

  QRAreaClipper({
    this.horizontalPadding = 16,
  });

  @override
  Path getClip(Size size) {
    double squareSize = size.width - (horizontalPadding * 2);
    double left = (size.width - squareSize) / 2;
    double top = (size.height - squareSize) / 2;
    double radius = 8;

    Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(left, top, squareSize, squareSize), Radius.circular(radius)))
      ..fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
