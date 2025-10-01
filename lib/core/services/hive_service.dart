import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jonnverse/app/theme/saved_theme.dart';
import 'package:jonnverse/ui/common/strings.dart';

class HiveService{
  static Future<void> initializeHive()async {
    await Hive.initFlutter();
    Hive.registerAdapter(ThemeModeAdapter());
    await Hive.openBox<ThemeMode>(AppStrings.themeKey);
    log('${AppStrings.hiveServiceLog}hive successfully initialized');
  }

  static Box<ThemeMode> themeBox = Hive.box(AppStrings.themeKey);

    ThemeMode? getThemeMode() {
    try {
      return themeBox.get(AppStrings.themeKey, defaultValue: ThemeMode.system);
    } catch (e) {
      throw Exception('${AppStrings.hiveServiceLog}getThemeMode failed: $e');
    }
  }

  Future<void> updateThemeMode({required ThemeMode theme}) async {
      try{
        await themeBox.put(AppStrings.themeKey, theme);
        log('${AppStrings.hiveServiceLog}theme mode updated to $theme');
      }catch(e){
        throw Exception('${AppStrings.hiveServiceLog}theme mode update failed: $e');
      }
  }

  Future<void> clearThemeSettingsStorage() async {
      try{
        await themeBox.clear();
        log('${AppStrings.hiveServiceLog}Theme box has been cleared');
      }catch(e){
        throw Exception('${AppStrings.hiveServiceLog}theme box clearing failed: $e');
      }
  }

  // void updateMessageList({required List<Message> messages, required Box<Message> box}) {
  //     try{
  //       box.clear();
  //       int i = 0;
  //       for (var message in messages) {
  //         box.put('message${i++}', message);
  //         log('added message $i to message list');
  //       }
  //       log('${messages.length} messages updated in order');
  //     }catch(e){
  //       log(e.toString());
  //     }
  // }

  static Future<void> closeHive() async {
      try{
        await Hive.close();
        log('${AppStrings.hiveServiceLog}All opened local storage boxes have been closed');
      } catch(e){
        throw Exception('${AppStrings.hiveServiceLog}Failed to close hive: $e');
      }

  }

}



///flutter pub run build_runner build