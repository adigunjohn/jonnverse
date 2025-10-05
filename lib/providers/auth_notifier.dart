import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/user.dart' as jonnverse;
import 'package:jonnverse/core/repos/auth_repo.dart';
import 'package:jonnverse/core/repos/connectivity_repo.dart';
import 'package:jonnverse/ui/common/strings.dart';

class AuthState{
  final bool isLoginLoading;
  final bool isRegisterLoading;
  final bool loggingOut;
  final jonnverse.User? user;
  AuthState({required this.user, this.isLoginLoading = false, this.isRegisterLoading = false, this.loggingOut = false});

  AuthState copyWith({bool? isLoginLoading, bool? isRegisterLoading, jonnverse.User? user,bool? loggingOut}){
    return AuthState(
      isLoginLoading: isLoginLoading ?? this.isLoginLoading,
      isRegisterLoading: isRegisterLoading ?? this.isRegisterLoading,
      user: user ?? this.user,
      loggingOut: loggingOut ?? this.loggingOut
    );
  }
}

class AuthNotifier extends Notifier<AuthState>{
  final AuthRepo _authRepo = locator<AuthRepo>();
  final ConnectivityRepo _connectivityRepo = locator<ConnectivityRepo>();
  @override
  AuthState build() => AuthState(user: jonnverse.User(uid: '', name: '', email: '',profilePic: ''));

  Future<String?> login(BuildContext context,{required String email, required String password}) async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    state = state.copyWith(isLoginLoading: true);
    try{
      final user = await _authRepo.signIn(email: email, password: password);
      state = state.copyWith(isLoginLoading: false);
      if(user != null){
        state = state.copyWith(user: user);
        return null;
      }else{ return 'User is null';}
    }
    on FirebaseAuthException catch(e){
      state = state.copyWith(isLoginLoading: false);
      return e.code;
    }
    catch(e){
      state = state.copyWith(isLoginLoading: false);
      return e.toString();
    }
  }

  Future<String?> loginWithGoogle(BuildContext context) async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    state = state.copyWith(isLoginLoading: true);
    try{
      final user = await _authRepo.signInWithGoogleAccount();
      state = state.copyWith(isLoginLoading: false);
      if(user != null){
        state = state.copyWith(user: user);
        return null;
      }else{ return 'User is null';}
    }
    on FirebaseAuthException catch(e){
      state = state.copyWith(isLoginLoading: false);
      return e.code;
    }
    catch(e){
      state = state.copyWith(isLoginLoading: false);
      return e.toString();
    }
  }

  Future<String?> register(BuildContext context,{required String email, required String password, required String fullName}) async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    state = state.copyWith(isRegisterLoading: true);
    try{
      final user = await _authRepo.signUp(email: email, password: password, fullName: fullName);
      state = state.copyWith(isRegisterLoading: false);
      if(user != null){
        state = state.copyWith(user: user);
        return null;
      }else{
        return 'User is null';
      }
    }
    on FirebaseAuthException catch(e){
      state = state.copyWith(isRegisterLoading: false);
      return e.code;
    }
    catch(e){
      state = state.copyWith(isRegisterLoading: false);
      return e.toString();
    }
  }

  Future<String?> registerWithGoogle(BuildContext context) async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    state = state.copyWith(isRegisterLoading: true);
    try{
      final user = await _authRepo.signUpWithGoogleAccount();
      state = state.copyWith(isRegisterLoading: false);
      if(user != null){
        state = state.copyWith(user: user);
        return null;
      }else{ return 'User is null';}
    }
    on FirebaseAuthException catch(e){
      state = state.copyWith(isRegisterLoading: false);
      return e.code;
    }
    catch(e){
      state = state.copyWith(isRegisterLoading: false);
      return e.toString();
    }
  }

  Future<String?> logout() async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    state = state.copyWith(loggingOut: true);
    try{
       await _authRepo.logout();
      state = state.copyWith(loggingOut: false, user: null);
      return null;
    }
    on FirebaseAuthException catch(e){
      state = state.copyWith(loggingOut: false);
      return e.code;
    }
    catch(e){
      state = state.copyWith(loggingOut: false);
      return e.toString();
    }
  }

}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);