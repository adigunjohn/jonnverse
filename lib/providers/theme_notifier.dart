import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/repos/theme_repo.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  final ThemeRepo _themeRepo = locator<ThemeRepo>();
  @override
  ThemeMode build() => _themeRepo.getThemeMode() ?? ThemeMode.system;

  Future<void> setThemeMode() async{
   await _themeRepo.setThemeMode(state);
  }

}
final themeProvider = NotifierProvider<ThemeNotifier,ThemeMode>(ThemeNotifier.new);