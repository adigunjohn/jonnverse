import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/enums/apptheme.dart';
import 'package:jonnverse/core/repos/theme_repo.dart';

class ThemeState {
  final ThemeMode themeMode;
  final int themeMessageIndex;
  final AppThemeMode appThemeMode;
  ThemeState({required this.themeMode, required this.themeMessageIndex, required this.appThemeMode});

  ThemeState copyWith({ThemeMode? themeMode, int? themeMessageIndex, AppThemeMode? appThemeMode}){
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      themeMessageIndex: themeMessageIndex ?? this.themeMessageIndex,
      appThemeMode: appThemeMode ?? this.appThemeMode,
    );
  }
}

class ThemeNotifier extends Notifier<ThemeState> {
  final ThemeRepo _themeRepo = locator<ThemeRepo>();
  ThemeState getThemeState(ThemeMode themeMode){
    final ThemeState initialState;
    if(themeMode == ThemeMode.light){
      initialState = ThemeState(themeMode: ThemeMode.light, themeMessageIndex: 1, appThemeMode: AppThemeMode.light);
    } else if(themeMode == ThemeMode.dark){
      initialState = ThemeState(themeMode: ThemeMode.dark, themeMessageIndex: 2, appThemeMode: AppThemeMode.dark);
    } else {
      initialState = ThemeState(themeMode: ThemeMode.system, themeMessageIndex: 0, appThemeMode: AppThemeMode.system);
    }
    return initialState;
  }
  @override
  ThemeState build() => getThemeState( _themeRepo.getThemeMode() ?? ThemeMode.system);

  void updateThemeState(AppThemeMode theme) async {
    if(theme == AppThemeMode.light){
      state = state.copyWith(themeMode: ThemeMode.light, themeMessageIndex: 1, appThemeMode: AppThemeMode.light);
    } else if(theme == AppThemeMode.dark){
      state = state.copyWith(themeMode: ThemeMode.dark, themeMessageIndex: 2, appThemeMode: AppThemeMode.dark);
    } else {
      state = state.copyWith(themeMode: ThemeMode.system, themeMessageIndex: 0, appThemeMode: AppThemeMode.system);
    }
    await _themeRepo.setThemeMode(state.themeMode);
  }


}
final themeProvider = NotifierProvider<ThemeNotifier,ThemeState>(ThemeNotifier.new);