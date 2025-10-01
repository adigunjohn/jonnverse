import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(),
    scaffoldBackgroundColor: kCGrey100Color,
    textTheme: TextTheme(
      titleLarge: kTSplashText.copyWith(color: kCBlackColor),
      bodyMedium: kTTextSize16.copyWith(color: kCBlackColor)
    ),
    iconTheme: const IconThemeData(color: kCBlackColor),
  );

  static ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(),
    scaffoldBackgroundColor: kCGrey900Color,
    textTheme: TextTheme(
      titleLarge: kTSplashText.copyWith(color: kCWhiteColor),
        bodyMedium: kTTextSize16.copyWith(color: kCWhiteColor)
    ),
    iconTheme: const IconThemeData(color: kCWhiteColor),
  );
}
