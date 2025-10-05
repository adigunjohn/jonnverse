import 'dart:developer';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/user.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/ui/common/strings.dart';

class UserRepo{
  final HiveService _hiveService = locator<HiveService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  User? getUser(){
    try{
      return _hiveService.getUser();
    }catch(e){
      log('${AppStrings.userRepoLog}failed to get user: $e');
      throw Exception('${AppStrings.userRepoLog}failed to get user: $e');
    }
  }

  bool isUserLoggedIn(){
    try{
      return _hiveService.getLoggedIn() ?? false;
    }catch(e){
      log('${AppStrings.userRepoLog}failed to check whether user is logged in: $e');
      throw Exception('${AppStrings.userRepoLog}failed to check whether user is logged in: $e');
    }
  }

  Stream<List<User>> getAllUsers(){
    try{
      final users = _firebaseService.getAllUsers();
      return users;
    }catch(e){
      log('${AppStrings.userRepoLog}failed to fetch all the available users: $e');
      throw Exception('Failed to fetch all the available users');
    }
  }


}