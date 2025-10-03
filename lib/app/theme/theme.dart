import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(),
    scaffoldBackgroundColor: kCGrey100Color,
    hintColor: kCGrey300Color,
    cardColor: kCGrey200Color,
    appBarTheme: AppBarTheme(
        color: kCBlueShadeColor,
      centerTitle: true,
    ),
    textTheme: TextTheme(
      titleLarge: kTSplashText,
      bodyLarge: kTTextSize18.copyWith(color: kCBlackColor),
      bodyMedium: kTTextSize16.copyWith(color: kCBlackColor),
      bodySmall: kTTextSize15.copyWith(color: kCBlackColor),
      labelSmall: kTTextSize12.copyWith(color: kCBlackColor),
      headlineLarge: kTTextSize21.copyWith(color: kCBlackColor),
      displaySmall: kTNavBarText,
      displayLarge: kTAppBarText,
      headlineSmall: kTTextSize12Grey,
      headlineMedium: kTTextSize16Grey,
        labelMedium: kTButtonText,
    ),
    iconTheme: const IconThemeData(color: kCBlackColor),
  );

  static ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(),
    scaffoldBackgroundColor: kCBlack87Color,
    hintColor: kCGrey900Color,
    cardColor: kCGrey800Color,
    appBarTheme: AppBarTheme(
      // color: kCDarkAppbarColor,
      centerTitle: true,
    ),
    textTheme: TextTheme(
      titleLarge: kTSplashText,
      bodyLarge: kTTextSize18.copyWith(color: kCWhiteColor),
      bodyMedium: kTTextSize16.copyWith(color: kCWhiteColor),
      bodySmall: kTTextSize15.copyWith(color: kCWhiteColor),
      labelSmall: kTTextSize12.copyWith(color: kCWhiteColor),
      headlineLarge: kTTextSize21.copyWith(color: kCWhiteColor),
      displaySmall: kTNavBarText,
      displayLarge: kTAppBarText,
      headlineSmall: kTTextSize12Grey,
      headlineMedium: kTTextSize16Grey,
      labelMedium: kTButtonText,
    ),
    iconTheme: const IconThemeData(color: kCWhiteColor),
  );
}
