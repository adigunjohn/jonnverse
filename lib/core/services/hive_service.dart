import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jonnverse/app/theme/saved_theme.dart';
import 'package:jonnverse/core/models/user.dart';
import 'package:jonnverse/ui/common/strings.dart';

class HiveService{
  static Future<void> initializeHive()async {
    await Hive.initFlutter();
    Hive.registerAdapter(ThemeModeAdapter());
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<ThemeMode>(AppStrings.themeKey);
    await Hive.openBox<User?>(AppStrings.userKey);
    await Hive.openBox<bool>(AppStrings.loggedInKey);
    log('${AppStrings.hiveServiceLog}hive successfully initialized');
  }

  static Box<ThemeMode> themeBox = Hive.box(AppStrings.themeKey);
  static Box<User?> userBox = Hive.box(AppStrings.userKey);
  static Box<bool> loggedInBox = Hive.box(AppStrings.loggedInKey);

  //For Theme
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

  //For User
  User? getUser() {
    try {
      return userBox.get(AppStrings.userKey);
    } catch (e) {
      throw Exception('${AppStrings.hiveServiceLog}getUser failed: $e');
    }
  }

  Future<void> updateUser({required User? user}) async {
    try{
      await userBox.put(AppStrings.userKey, user);
      log('${AppStrings.hiveServiceLog}user updated to ${user.toString()}');
    }catch(e){
      throw Exception('${AppStrings.hiveServiceLog}user update failed: $e');
    }
  }

  Future<void> clearUserStorage() async {
    try{
      await userBox.clear();
      log('${AppStrings.hiveServiceLog}user box has been cleared');
    }catch(e){
      throw Exception('${AppStrings.hiveServiceLog}user box clearing failed: $e');
    }
  }

  //For LoggedIn
  bool? getLoggedIn() {
    try {
      return loggedInBox.get(AppStrings.loggedInKey, defaultValue: false);
    } catch (e) {
      throw Exception('${AppStrings.hiveServiceLog}getLoggedIn failed: $e');
    }
  }

  Future<void> updateLoggedIn({required bool loggedIn}) async {
    try{
      await loggedInBox.put(AppStrings.loggedInKey, loggedIn);
      log('${AppStrings.hiveServiceLog}loggedIn updated to $loggedIn');
    }catch(e){
      throw Exception('${AppStrings.hiveServiceLog}loggedIn update failed: $e');
    }
  }

  Future<void> clearLoggedInStorage() async {
    try{
      await loggedInBox.clear();
      log('${AppStrings.hiveServiceLog}user box has been cleared');
    }catch(e){
      throw Exception('${AppStrings.hiveServiceLog}loggedIn box clearing failed: $e');
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