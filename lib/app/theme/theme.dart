import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(),
    scaffoldBackgroundColor: kCGrey100Color,
    textTheme: TextTheme(
      titleLarge: kTSplashText.copyWith(color: kCBlackColor),
      bodyLarge: kTTextSize18.copyWith(color: kCBlackColor),
      bodyMedium: kTTextSize16.copyWith(color: kCBlackColor),
      bodySmall: kTTextSize15.copyWith(color: kCBlackColor),
      labelSmall: kTTextSize12.copyWith(color: kCBlackColor),
      displaySmall: kTNavBarText,
    ),
    iconTheme: const IconThemeData(color: kCBlackColor),
  );

  static ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(),
    scaffoldBackgroundColor: kCGrey900Color,
    textTheme: TextTheme(
      titleLarge: kTSplashText.copyWith(color: kCWhiteColor),
      bodyLarge: kTTextSize18.copyWith(color: kCWhiteColor),
      bodyMedium: kTTextSize16.copyWith(color: kCWhiteColor),
      bodySmall: kTTextSize15.copyWith(color: kCWhiteColor),
      labelSmall: kTTextSize12.copyWith(color: kCWhiteColor),
      displaySmall: kTNavBarText,
    ),
    iconTheme: const IconThemeData(color: kCWhiteColor),
  );
}
