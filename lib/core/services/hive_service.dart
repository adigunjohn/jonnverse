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
    ThemeMode? getThemeMode() => themeBox.get(AppStrings.themeKey, defaultValue: ThemeMode.system);

  Future<void> updateThemeMode({required ThemeMode theme}) async {
      await themeBox.put(AppStrings.themeKey, theme);
      log('${AppStrings.hiveServiceLog}theme mode updated to $theme');
  }

  Future<void> clearThemeSettingsStorage() async {
      await themeBox.clear();
      log('${AppStrings.hiveServiceLog}Theme box has been cleared');
  }

  //For User
  User? getUser() => userBox.get(AppStrings.userKey);

  Future<void> updateUser({required User? user}) async {
      await userBox.put(AppStrings.userKey, user);
      log('${AppStrings.hiveServiceLog}user updated to ${user.toString()}');
  }

  Future<void> clearUserStorage() async {
      await userBox.clear();
      log('${AppStrings.hiveServiceLog}user box has been cleared');
  }

  //For LoggedIn
  bool? getLoggedIn() => loggedInBox.get(AppStrings.loggedInKey, defaultValue: false);

  Future<void> updateLoggedIn({required bool loggedIn}) async {
      await loggedInBox.put(AppStrings.loggedInKey, loggedIn);
      log('${AppStrings.hiveServiceLog}loggedIn updated to $loggedIn');
  }

  Future<void> clearLoggedInStorage() async {
      await loggedInBox.clear();
      log('${AppStrings.hiveServiceLog}user box has been cleared');
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
        await Hive.close();
        log('${AppStrings.hiveServiceLog}All opened local storage boxes have been closed');
  }

}



///flutter pub run build_runner build