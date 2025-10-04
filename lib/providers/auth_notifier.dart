import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/user.dart' as jonnverse;
import 'package:jonnverse/core/repos/auth_repo.dart';
import 'package:jonnverse/core/repos/connectivity_repo.dart';
import 'package:jonnverse/core/services/dialog_service.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/ui/screens/nav_view.dart';

class AuthState{
  bool isLoginLoading;
  bool isRegisterLoading;
  jonnverse.User user;
  AuthState({required this.user, this.isLoginLoading = false, this.isRegisterLoading = false,});

  AuthState copyWith({bool? isLoginLoading, bool? isRegisterLoading, jonnverse.User? user,}){
    return AuthState(
      isLoginLoading: isLoginLoading ?? this.isLoginLoading,
      isRegisterLoading: isRegisterLoading ?? this.isRegisterLoading,
      user: user ?? this.user
    );
  }
}

class AuthNotifier extends Notifier<AuthState>{
  final AuthRepo _authRepo = locator<AuthRepo>();
  final ConnectivityRepo _connectivityRepo = locator<ConnectivityRepo>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  AuthState build() => AuthState(user: jonnverse.User(uid: '', name: '', email: ''));

  Future<void> login(BuildContext context,{required String email, required String password}) async{
    if(await _connectivityRepo.hasInternet() == false)return;
    state = state.copyWith(isLoginLoading: true);
    try{
      final user = await _authRepo.signIn(email: email, password: password);
      state = state.copyWith(isLoginLoading: false);
      if(user != null){
        state = state.copyWith(user: user);
        _navigationService.pushNamed(NavView.id);
      }else{ log('User is null');}
    }
    on FirebaseAuthException catch(e){
      state = state.copyWith(isLoginLoading: false);
      _dialogService.showAlertDialog(context, title: 'Authentication Error',subtitle: e.code);
    }
    catch(e){
      state = state.copyWith(isLoginLoading: false);
      _dialogService.showAlertDialog(context, title: 'Authentication Error',subtitle: '$e');
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async{
    if(await _connectivityRepo.hasInternet() == false)return;
    state = state.copyWith(isLoginLoading: true);
    try{
      final user = await _authRepo.signInWithGoogleAccount();
      state = state.copyWith(isLoginLoading: false);
      if(user != null){
        state = state.copyWith(user: user);
        _navigationService.pushNamed(NavView.id);
      }else{ log('User is null');}
    }
    on FirebaseAuthException catch(e){
      state = state.copyWith(isLoginLoading: false);
      _dialogService.showAlertDialog(context, title: 'Authentication Error',subtitle: e.code);
    }
    catch(e){
      state = state.copyWith(isLoginLoading: false);
      _dialogService.showAlertDialog(context, title: 'Authentication Error',subtitle: '$e');
    }
  }

  Future<void> register(BuildContext context,{required String email, required String password, required String fullName}) async{
    if(await _connectivityRepo.hasInternet() == false)return;
    state = state.copyWith(isRegisterLoading: true);
    try{
      final user = await _authRepo.signUp(email: email, password: password, fullName: fullName);
      state = state.copyWith(isRegisterLoading: false);
      if(user != null){
        state = state.copyWith(user: user);
        _navigationService.pushNamed(NavView.id);
      }else{ log('User is null');}
    }
    on FirebaseAuthException catch(e){
      state = state.copyWith(isRegisterLoading: false);
      _dialogService.showAlertDialog(context, title: 'Authentication Error',subtitle: e.code);
    }
    catch(e){
      state = state.copyWith(isRegisterLoading: false);
      _dialogService.showAlertDialog(context, title: 'Authentication Error',subtitle: '$e');
    }
  }

  Future<void> registerWithGoogle(BuildContext context) async{
    if(await _connectivityRepo.hasInternet() == false)return;
    state = state.copyWith(isRegisterLoading: true);
    try{
      final user = await _authRepo.signUpWithGoogleAccount();
      state = state.copyWith(isRegisterLoading: false);
      if(user != null){
        state = state.copyWith(user: user);
        _navigationService.pushNamed(NavView.id);
      }else{ log('User is null');}
    }
    on FirebaseAuthException catch(e){
      state = state.copyWith(isRegisterLoading: false);
      _dialogService.showAlertDialog(context, title: 'Authentication Error',subtitle: e.code);
    }
    catch(e){
      state = state.copyWith(isRegisterLoading: false);
      _dialogService.showAlertDialog(context, title: 'Authentication Error',subtitle: '$e');
    }
  }

}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);