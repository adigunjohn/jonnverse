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

  String? updateUser(User? value) {
    try{
      state = state.copyWith(user: value);
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
  }

  void clearProfilePicture(){
    state = state.copyWith(profileImageName: null, profileImagePath: null);
  }
  Future<String?> uploadProfilePicture(ImageSource source)async{
    if(await _connectivityRepo.hasInternet() == false)return AppStrings.noInternet;
    try{
      pickProfileImage(source);
      final url = await _userRepo.uploadProfilePicture(filename: '${state.user!.email}/${state.profileImageName!}', file: File(state.profileImagePath!));
      clearProfilePicture();
      final user = User(
          uid: state.user!.uid,
          name: state.user!.name,
          email: state.user!.email,
          profilePic: url);
      state = state.copyWith(user: user);
      updateUserFirestore(user);
      return null;
    }catch(e){
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

}
final userProvider = NotifierProvider<UserNotifier, UserState>(UserNotifier.new);