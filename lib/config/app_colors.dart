import 'package:flutter/material.dart';

class AppColors {
  static Color body1 = const Color(0xFF000000);
  static Color body2 = const Color(0xFFFFFFFF);
  static Color body3 = const Color(0xFF535353);

  static Color lightGrey1 = const Color(0xFFF3F3F3);
  static Color lightGrey2 = const Color(0xFFE9E9E9);
  static Color middleGrey = const Color(0xFFC7C7C7);
  static Color darkGrey = const Color(0xFF969696);

  static Color divider = const Color(0xFFC7C7C7);
  static Color lineNumbers = const Color(0xFFF3F3F3);

  static Gradient primaryGradient = const RadialGradient(
    radius: 1,
    center: Alignment(-0.6, -0.6),
    colors: <Color>[
      Color(0xFF000000),
      Color(0xFF42D2FF),
      Color(0xFF939393),
      Color(0xFF000000),
    ],
  );
}
