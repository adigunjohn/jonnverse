import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/user.dart';
import 'package:jonnverse/core/repos/user_repo.dart';
import 'package:jonnverse/providers/auth_notifier.dart';

final userRepoProvider = Provider<UserRepo>((ref) => locator<UserRepo>());
final allUsersStreamProvider = StreamProvider<List<User>>((ref){
  final repo = ref.watch(userRepoProvider);
  final auth = ref.watch(authProvider);
  final userEmail = auth.user?.email;
  if (userEmail == null) {
    return Stream.value(<User>[]);
  }
  return repo.getAllUsers(userEmail);
});
