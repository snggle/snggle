import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';

class ThemeConfig {
  ThemeData _baseTheme = ThemeData(
    fontFamily: 'Bauhaus',
    brightness: Brightness.light,
  );

  ThemeData buildTheme() {
    _baseTheme = _baseTheme.copyWith(
      textTheme: textTheme,
    );

    return _baseTheme.copyWith(
      appBarTheme: appBarTheme,
      scaffoldBackgroundColor: AppColors.body2,
      canvasColor: AppColors.body2,
      textButtonTheme: textButtonTheme,
    );
  }

  AppBarTheme get appBarTheme {
    return _baseTheme.appBarTheme.copyWith(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      titleTextStyle: _baseTheme.textTheme.titleLarge?.copyWith(
        fontSize: 20,
        letterSpacing: 2,
        fontWeight: FontWeight.w400,
        color: AppColors.body1,
      ),
    );
  }

  TextTheme get textTheme {
    TextTheme baseTheme = _baseTheme.textTheme.apply(fontFamily: 'Bauhaus', bodyColor: AppColors.body1);
    TextStyle? baseTextStyle = baseTheme.bodyMedium?.copyWith(letterSpacing: 1.5, height: 1.1, fontWeight: FontWeight.w400);

    baseTheme = baseTheme.copyWith(
      titleMedium: baseTextStyle?.copyWith(fontSize: 14, letterSpacing: 2.18, height: 1.1),
      titleSmall: baseTextStyle?.copyWith(fontSize: 13.05, letterSpacing: 2.18, height: 1.1),
      labelMedium: baseTextStyle?.copyWith(fontSize: 12, letterSpacing: 0.72, height: 1),
      bodyMedium: baseTextStyle?.copyWith(fontSize: 14, letterSpacing: 1.5, height: 1.1),
    );
    return baseTheme;
  }

  TextButtonThemeData get textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.body1,
        textStyle: _baseTheme.textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          letterSpacing: 4,
          fontWeight: FontWeight.w400,
          color: AppColors.body1,
          fontFamily: 'Bauhaus',
        ),
      ),
    );
  }
}
