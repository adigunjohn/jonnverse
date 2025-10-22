import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/user.dart';
import 'package:jonnverse/core/repos/connectivity_repo.dart';
import 'package:jonnverse/core/repos/user_repo.dart';
import 'package:jonnverse/core/services/file_picker_service.dart';
import 'package:jonnverse/ui/common/strings.dart';

class UserState{
  final bool loading;
  final User? user;
  final String? profileImageName;
  final String? profileImagePath;
  UserState({required this.user, this.loading = false, this.profileImageName, this.profileImagePath});

  UserState copyWith({bool? isLoginLoading, bool? isRegisterLoading, User? user,bool? loading, String? profileImageName, String? profileImagePath}){
    return UserState(
        user: user ?? this.user,
        loading: loading ?? this.loading,
        profileImageName: profileImageName ?? this.profileImageName,
        profileImagePath: profileImagePath ?? this.profileImagePath
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  final UserRepo _userRepo = locator<UserRepo>();
  final FilePickerService _filePickerService = locator<FilePickerService>();
  final ConnectivityRepo _connectivityRepo = locator<ConnectivityRepo>();
  @override
  UserState build() => UserState(user: _userRepo.getUser());

  Future<String?> updateUser(User? value) async{
    try{
      state = state.copyWith(user: value);
      await _userRepo.updateUserLocally(value!);
      return null;
    }catch(e){
      return 'Failed to update user';
    }
  }

  Future<String?> updateUserFirestore(User value) async{
    try{
      final user = await _userRepo.updateUser(value.uid, value);
      state = state.copyWith(user: user);
      return null;
    }catch(e){
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> pickProfileImage(ImageSource source)async{
    clearProfilePicture();
    final result = await _filePickerService.pickImage(source: source);
    if(result != null){
      state = state.copyWith(profileImageName: result.name, profileImagePath: result.path);
    }
    else{
      log('No image picked');
    }
  }

  void clearProfilePicture(){
    state = state.copyWith(profileImageName: null, profileImagePath: null);
    log('Picked profile picture cleared');
  }
  Future<String?> uploadProfilePicture(ImageSource source)async{
    state = state.copyWith(loading: true);
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    try{
      await pickProfileImage(source);
      if(state.profileImagePath == null) return 'No image selected';
      final url = await _userRepo.uploadProfilePicture(filename: '${state.user!.email}/${state.profileImageName!}', file: File(state.profileImagePath!));
      final user = User(
          uid: state.user!.uid,
          name: state.user!.name,
          email: state.user!.email,
          profilePic: url);
      state = state.copyWith(user: user);
      updateUserFirestore(user);
      clearProfilePicture();
      return null;
    }catch(e){
      clearProfilePicture();
      return e.toString().replaceFirst('Exception: ', '');
    } finally{
      state = state.copyWith(loading: false);
    }
  }

  Future<(String?,String?)> toggleBlockUser(String otherUserId) async {
    if (state.user == null) return ('Invalid User, kindly login again', null);
    if(await _connectivityRepo.hasInternet() == false)return (AppStrings.noInternet, null);
    String result;
    try {
      final updatedUser = await _userRepo.getOtherUsersDetails(state.user!.uid);
      if (updatedUser != null) {
        await updateUser(updatedUser);
      }
      final currentUser = state.user;
      if (currentUser == null) return ('Invalid User, kindly login again',null);
      final isBlocked = currentUser.blockedUsers?.contains(otherUserId) ?? false;
      User user;
      final blockedList = currentUser.blockedUsers ?? [];
      if (isBlocked) {
        if (blockedList.isNotEmpty && blockedList.contains(otherUserId)) blockedList.remove(otherUserId);
        result = 'unblocked';
      } else {
        blockedList.add(otherUserId);
        result = 'blocked';
      }
      user = User(uid: currentUser.uid, name: currentUser.name, email: currentUser.email, profilePic: currentUser.profilePic, blockedUsers: blockedList);
      await _userRepo.blockOrUnblockUser(value: user);
      await updateUser(user);
      return (null,result);
    } catch (e) {
      log('Error toggling block status: $e');
      return (e.toString().replaceFirst('Exception: ', ''),null);
    }
  }

}
final userProvider = NotifierProvider<UserNotifier, UserState>(UserNotifier.new);