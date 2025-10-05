import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/user.dart' as jonnverse;
import 'package:jonnverse/core/repos/auth_repo.dart';
import 'package:jonnverse/core/repos/connectivity_repo.dart';
import 'package:jonnverse/core/repos/user_repo.dart';
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
  final UserRepo _userRepo = locator<UserRepo>();
  final ConnectivityRepo _connectivityRepo = locator<ConnectivityRepo>();
  @override
  AuthState build() => AuthState(user: _userRepo.getUser());

  Future<String?> login(BuildContext context,{required String email, required String password}) async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    state = state.copyWith(isLoginLoading: true);
    try{
      final user = await _authRepo.signIn(email: email, password: password);
      if(user != null){
        state = state.copyWith(user: user);
        return null;
      }else{ return 'User is null';}
    }
    catch(e){
      return e.toString().replaceFirst('Exception: ', '');
    } finally{
      state = state.copyWith(isLoginLoading: false);
    }
  }

  Future<String?> loginWithGoogle(BuildContext context) async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    state = state.copyWith(isLoginLoading: true);
    try{
      final user = await _authRepo.signUpOrInWithGoogleAccount();
      if(user != null){
        state = state.copyWith(user: user);
        return null;
      }else{ return 'User is null';}
    }
    catch(e){
      return e.toString().replaceFirst('Exception: ', '');
    }finally{
      state = state.copyWith(isLoginLoading: false);
    }
  }

  Future<String?> register(BuildContext context,{required String email, required String password, required String fullName}) async {
    if (await _connectivityRepo.hasInternet() == false) return AppStrings.noInternet;
    state = state.copyWith(isRegisterLoading: true);
    try {
      final user = await _authRepo.signUp(
          email: email, password: password, fullName: fullName);
      if (user != null) {
        state = state.copyWith(user: user);
        return null;
      } else {
        return 'User is null';
      }
    }
    catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
    finally {
      state = state.copyWith(isRegisterLoading: false);
    }
  }

  Future<String?> registerWithGoogle(BuildContext context) async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    state = state.copyWith(isRegisterLoading: true);
    try{
      final user = await _authRepo.signUpOrInWithGoogleAccount();
      if(user != null){
        state = state.copyWith(user: user);
        return null;
      }else{ return 'User is null';}
    }
    catch(e){
      return e.toString().replaceFirst('Exception: ', '');
    }finally{
      state = state.copyWith(isRegisterLoading: false);
    }
  }

  Future<String?> logout() async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    state = state.copyWith(loggingOut: true);
    try{
       await _authRepo.logout();
      state = state.copyWith(user: null);
      return null;
    }
    catch(e){
      return e.toString().replaceFirst('Exception: ', '');
    }
    finally{
      state = state.copyWith(loggingOut: false);
    }
  }

}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);