import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisibilityState{
  final bool isLoginPasswordVisible;
  final bool isRegisterPasswordVisible;
  final bool isBlockedUsersVisible;

  VisibilityState({
    this.isBlockedUsersVisible = false, this.isRegisterPasswordVisible = true, this.isLoginPasswordVisible = true,
});

  VisibilityState copyWith({bool? isLoginPasswordVisible, bool? isRegisterPasswordVisible, bool? isBlockedUsersVisible}){
    return VisibilityState(
        isBlockedUsersVisible: isBlockedUsersVisible ?? this.isBlockedUsersVisible,
      isLoginPasswordVisible: isLoginPasswordVisible ?? this.isLoginPasswordVisible,
      isRegisterPasswordVisible: isRegisterPasswordVisible ?? this.isRegisterPasswordVisible,
    );
  }
}

class VisibilityNotifier extends Notifier<VisibilityState> {
  @override
  VisibilityState build() => VisibilityState();

  void updateLoginPasswordVisibility(){
    state = state.copyWith(isLoginPasswordVisible: !state.isLoginPasswordVisible);
  }
  void updateRegisterPasswordVisibility(){
    state = state.copyWith(isRegisterPasswordVisible: !state.isRegisterPasswordVisible);
  }
  void updateBlockedUsersVisibility(){
    state = state.copyWith(isBlockedUsersVisible: !state.isBlockedUsersVisible);
  }
}

final visibilityProvider = NotifierProvider<VisibilityNotifier,VisibilityState>(VisibilityNotifier.new);
