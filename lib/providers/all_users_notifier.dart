import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/user.dart';
import 'package:jonnverse/core/repos/user_repo.dart';
import 'package:jonnverse/providers/user_notifier.dart';

final userRepoProvider = Provider<UserRepo>((ref) => locator<UserRepo>());
final allUsersStreamProvider = StreamProvider<List<User>>((ref){
  final repo = ref.watch(userRepoProvider);
  final user = ref.watch(userProvider);
  final userEmail = user.user?.email;
  if (userEmail == null) {
    return Stream.value(<User>[]);
  }
  return repo.getAllUsers(userEmail);
});

final otherUserFutureProvider = FutureProvider.family<User?,String>((ref, id) {
  final repo = ref.watch(userRepoProvider);
  return repo.getOtherUsersDetails(id);
});