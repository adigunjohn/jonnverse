import 'package:flutter/material.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/ui/common/strings.dart';

class ThemeRepo {
  final HiveService _hiveService = locator<HiveService>();

  ThemeMode? getThemeMode(){
    try{
      final themeMode = _hiveService.getThemeMode();
      return themeMode;
    }catch(e){
      throw Exception('${AppStrings.themeRepoLog}Failed to get themeMode: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode theme) async{
    try{
      await _hiveService.updateThemeMode(theme: theme);
    }catch(e){
      throw Exception('${AppStrings.themeRepoLog}Failed to update themeMode: $e');
    }
  }

  Future deleteThemeMode() async{
    try{
      await _hiveService.clearThemeSettingsStorage();
    }catch(e){
      throw Exception('${AppStrings.themeRepoLog}Failed to delete themeMode: $e');
    }
  }

}