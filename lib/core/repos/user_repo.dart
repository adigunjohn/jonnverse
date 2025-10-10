import 'dart:developer';
import 'dart:io';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/user.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/core/services/supabase_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class UserRepo{
  final HiveService _hiveService = locator<HiveService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final SupabaseService _supabaseService = locator<SupabaseService>();



  User? getUser(){
    try{
      return _hiveService.getUser();
    }catch(e){
      log('${AppStrings.userRepoLog}failed to get user: $e');
      throw Exception('${AppStrings.userRepoLog}failed to get user: $e');
    }
  }

  Future<void> updateUserLocally(User value)async{
    try{
      await _hiveService.updateUser(user: value);
      log('${AppStrings.userRepoLog}user updated successfully ${value.toString()}');
    }catch(e){
      log('${AppStrings.userRepoLog}failed to update user on hive: $e');
      throw Exception('${AppStrings.userRepoLog}failed to update user details');
    }
  }
  Future<User> updateUser(String id, User value)async{
    try{
      await _firebaseService.saveUser(id, value, merge: true);
      final user = await _firebaseService.getUserDetails(id);
      await _hiveService.updateUser(user: user);
      log('${AppStrings.userRepoLog}user updated successfully ${user.toString()}');
      return user;
    }catch(e){
      log('${AppStrings.userRepoLog}failed to update user: $e');
      throw Exception('${AppStrings.userRepoLog}failed to update user details');
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

  Stream<List<User>> getAllUsers(String? currentUserEmail){
    try{
      final users = _firebaseService.getAllUsers(currentUserEmail ?? getUser()!.email);
      return users;
    }catch(e){
      log('${AppStrings.userRepoLog}failed to fetch all the available users: $e');
      throw Exception('Failed to fetch all the available users');
    }
  }

  Future<User> getOtherUsersDetails(String id) async{
    try{
      final user = await _firebaseService.getUserDetails(id);
      return user;
    }catch(e){
      log('${AppStrings.userRepoLog}failed to fetch user details: $e');
      throw Exception('Failed to fetch user details');
    }
  }
  Future<String> uploadProfilePicture({required String filename, required File file}) async{
    try{
      final url = await _supabaseService.uploadFile(file, 'profilepictures/$filename');
      return url;
    }
    on supabase.StorageException catch(e){
      log('${AppStrings.chatRepoLog}Supabase Error uploading Profile picture: ${e.statusCode} - ${e.error}  - ${e.message}');
      throw Exception('Failed to upload profile picture. Please try again.');
    }
    catch(e){
      log('${AppStrings.chatRepoLog}Error uploading Profile picture: $e');
      throw Exception('Failed to upload profile picture. Please try again');
    }
  }

}