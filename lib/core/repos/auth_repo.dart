import 'dart:developer';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/core/models/user.dart' as jonnverse;

class AuthRepo{
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final HiveService _hiveService = locator<HiveService>();

  Future<jonnverse.User?> signUp({required String email, required String password, required String fullName}) async{
    try{
      final userCredential = await _firebaseService.signUp(email: email, password: password);
      log('${AppStrings.authRepoLog}account created, proceeding to save user details');
      final user = userCredential.user;
      if(user == null) return null;
        final jonnverse.User value = jonnverse.User(uid: user.uid, name: fullName, email: user.email!,profilePic: '');
        await _firebaseService.saveUser(user, value);
        await _hiveService.updateUser(user: value);
        await _hiveService.updateLoggedIn(loggedIn: true);
        return value;
    }catch(e){
      throw Exception('${AppStrings.authRepoLog}Unknown Sign Up Error: $e');
    }
  }


  Future<jonnverse.User?> signIn({required String email, required String password}) async{
    try{
      final userCredential = await _firebaseService.signIn(email: email, password: password);
      log('${AppStrings.authRepoLog}account logged in, proceeding to save user details');
      final user = userCredential.user;
      if(user == null) return null;
        final userDetails = await _firebaseService.getUserDetails(user.uid);
        final jonnverse.User value = jonnverse.User(uid: userDetails.uid, name: userDetails.name, email: userDetails.email,profilePic: userDetails.profilePic);
        await _hiveService.updateUser(user: value);
        await _hiveService.updateLoggedIn(loggedIn: true);
        return value;
    }catch(e){
      throw Exception('${AppStrings.authRepoLog}Unknown Sign In Error: $e');
    }
  }


  Future<jonnverse.User?> signUpWithGoogleAccount() async{
    try{
      final userCredential = await _firebaseService.signUpOrInWithGoogle();
      final user = userCredential.user;
      if(user == null) return null;
        final jonnverse.User value = jonnverse.User(uid: user.uid, name: user.displayName ?? 'No Full Name', email: user.email!,profilePic: '');
        await _firebaseService.saveUser(user, value);
        await _hiveService.updateUser(user: value);
        await _hiveService.updateLoggedIn(loggedIn: true);
      return value;
    }catch(e){
      throw Exception('${AppStrings.authRepoLog}Unknown Sign Up with Google Error: $e');
    }
  }

  Future<jonnverse.User?> signInWithGoogleAccount() async{
    try{
      final userCredential = await _firebaseService.signUpOrInWithGoogle();
      final user = userCredential.user;
      if(user == null) return null;
        final userDetails = await _firebaseService.getUserDetails(user.uid);
        final jonnverse.User value = jonnverse.User(uid: userDetails.uid, name: userDetails.name, email: userDetails.email, profilePic: userDetails.profilePic);
        await _hiveService.updateUser(user: value);
        await _hiveService.updateLoggedIn(loggedIn: true);
        return value;
    }catch(e){
      throw Exception('${AppStrings.authRepoLog}Unknown Sign In with Google Error: $e');
    }
  }

  Future<void> logout() async{
    try{
      await _firebaseService.signOut();
      await _hiveService.updateUser(user: null);
      await _hiveService.updateLoggedIn(loggedIn: false);
    }catch(e){
      throw Exception('${AppStrings.authRepoLog}Unknown Error logging out: $e');
    }
}

}