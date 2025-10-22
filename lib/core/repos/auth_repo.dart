import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/ui/common/exception_handler.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/core/models/user.dart' as jonnverse;

class AuthRepo{
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final HiveService _hiveService = locator<HiveService>();

  Future<jonnverse.User?> signUp({required String email, required String password, required String fullName}) async{
    try{
      final userCredential = await _firebaseService.signUp(email: email, password: password);
      final user = userCredential.user;
      if(user == null) return null;
      log('${AppStrings.authRepoLog}account created, proceeding to save user details');
        final jonnverse.User value = jonnverse.User(uid: user.uid, name: fullName, email: user.email!,profilePic: '', blockedUsers: []);
        await _firebaseService.saveUser(user.uid, value);
        await _hiveService.updateUser(user: value);
        await _hiveService.updateLoggedIn(loggedIn: true);
        return value;
    } on FirebaseAuthException catch(e){
      log('${AppStrings.authRepoLog}Firebase Auth Error during Sign Up: ${e.code} - ${e.message}');
      throw Exception(ExceptionHandler.getSignUpErrorMessage(e.code));
    }on FirebaseException catch(e){
      log('${AppStrings.authRepoLog}Firebase Error during Sign Up: ${e.code} - ${e.message}');
      throw Exception(ExceptionHandler.getSignUpErrorMessage(e.code));
    }
    catch(e){
      log('${AppStrings.authRepoLog}Unknown Sign Up Error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }


  Future<jonnverse.User?> signIn({required String email, required String password}) async{
    try{
      final userCredential = await _firebaseService.signIn(email: email, password: password);
      final user = userCredential.user;
      if(user == null) return null;
      log('${AppStrings.authRepoLog}account logged in, proceeding to save user details');
        final userDetails = await _firebaseService.getUserDetails(user.uid);
        final jonnverse.User value = jonnverse.User(uid: userDetails.uid, name: userDetails.name, email: userDetails.email,profilePic: userDetails.profilePic, blockedUsers: userDetails.blockedUsers);
        await _hiveService.updateUser(user: value);
        await _hiveService.updateLoggedIn(loggedIn: true);
        return value;
    }on FirebaseAuthException catch(e){
      log('${AppStrings.authRepoLog}Firebase Auth Error during Sign In: ${e.code} - ${e.message}');
      throw Exception(ExceptionHandler.getSignInErrorMessage(e.code));
    }on FirebaseException catch(e){
      log('${AppStrings.authRepoLog}Firebase Error during Sign In: ${e.code} - ${e.message}');
      throw Exception(ExceptionHandler.getSignInErrorMessage(e.code));
    }catch(e){
      log('${AppStrings.authRepoLog}Unknown Sign In Error: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }


  Future<jonnverse.User?> signUpOrInWithGoogleAccount() async{
    try{
      final userCredential = await _firebaseService.signUpOrInWithGoogle();
      final user = userCredential.user;
      if(user == null) return null;
        final jonnverse.User value = jonnverse.User(uid: user.uid, name: user.displayName ?? 'No Full Name', email: user.email!,profilePic: '',blockedUsers: []);
      await _firebaseService.saveUser(user.uid, value, merge: true);
        await _hiveService.updateUser(user: value);
        await _hiveService.updateLoggedIn(loggedIn: true);
      return value;
    }on FirebaseAuthException catch(e){
      log('${AppStrings.authRepoLog}Firebase Auth Error during google sign Up/In: ${e.code} - ${e.message}');
      throw Exception(ExceptionHandler.getGeneralAuthErrorMessage(e.code));
    }on FirebaseException catch(e){
      log('${AppStrings.authRepoLog}Firebase Error during Google Sign Up/In: ${e.code} - ${e.message}');
      throw Exception(ExceptionHandler.getGeneralAuthErrorMessage(e.code));
    }catch(e){
      log('${AppStrings.authRepoLog}Unknown Google Sign Up/In Error: $e');
      throw Exception('An unexpected error occurred with Google sign in. Please try again.');}
  }

  Future<void> logout() async{
    try{
      await _firebaseService.signOut();
      await _hiveService.updateUser(user: null);
      await _hiveService.updateLoggedIn(loggedIn: false);
    }on FirebaseAuthException catch(e){
      log('${AppStrings.authRepoLog}Firebase Auth Error logging out: ${e.code} - ${e.message}');
      throw Exception('Failed to log out. Please try again.');
    }on FirebaseException catch(e){
      log('${AppStrings.authRepoLog}Firebase Error during logout: ${e.code} - ${e.message}');
      throw Exception('Failed to log out. Please try again.');
    }catch(e){
      log('${AppStrings.authRepoLog}Unknown Error logging out: $e');
      throw Exception('Failed to log out. Please try again.');
    }
  }

}