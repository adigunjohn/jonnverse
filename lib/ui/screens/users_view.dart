import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/providers/all_users_notifier.dart';
import 'package:jonnverse/providers/user_notifier.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/users_tile.dart';
import 'package:jonnverse/ui/screens/chat_view.dart';

class UsersView extends ConsumerWidget {
  UsersView({super.key});
  static const String id = Routes.usersView;
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.watch(allUsersStreamProvider);
    final sender = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 5),
              child: Icon(
                Icons.refresh_rounded,
                color: kCWhiteColor,
                size: usersIconSize,
              ),
            ),
          ),
        ],
        title: Text(
          AppStrings.users,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
          child:
          // StreamBuilder(stream: UserRepo().getAllUsers(),
          //         builder: (context, snapshot){
          //           if(snapshot.connectionState == ConnectionState.waiting){
          //             return Center(child: CircularProgressIndicator(color: kCAccentColor,),);
          //           }
          //           if(snapshot.hasData){
          //             final allUsers = snapshot.data!;
          //             if (allUsers.isEmpty) {
          //               return Center(
          //                 child: Text(
          //                   'No messages yet',
          //                   style: Theme.of(context).textTheme.bodySmall,
          //                   maxLines: 2,
          //                   textAlign: TextAlign.center,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               );
          //             }
          //             return Column(
          //               children: [
          //                 Text(
          //                   '${AppStrings.availableUsers} (${allUsers.length})',
          //                   style: Theme.of(context).textTheme.bodyMedium,
          //                 ),
          //                 SizedBox(height: 10),
          //                 Expanded(
          //                   child:
          //                   allUsers.isEmpty
          //                       ? Center(
          //                     child: Text(
          //                       AppStrings.emptyUsers,
          //                       style: Theme.of(context).textTheme.bodySmall,
          //                       maxLines: 2,
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   )
          //                       : ListView.builder(
          //                     itemCount: allUsers.length,
          //                     itemBuilder: (_, index) {
          //                       final user = allUsers[index];
          //                       return UsersTile(
          //                         userName: user.name!,
          //                         userMail: user.email,
          //                         onTap: () {
          //                           _navigationService.push(ChatView(
          //                             userId: sender.user?.uid,
          //                             receiverName: user.name,
          //                             receiverMail: user.email,
          //                             receiverId: user.uid,
          //                             userMail: sender.user?.email,
          //                             userName: sender.user?.name,
          //                           ));
          //                         },
          //                       );
          //                     },
          //                   ),
          //                 ),
          //               ],
          //             );
          //           }
          //           if(snapshot.hasError){
          //             log('Error occurred while fetching all the available users',);
          //             return Center(child: Text(
          //               'Failed to fetch all the available users',
          //               style: Theme.of(context).textTheme.bodyMedium,
          //             ),);
          //           }
          //           log('Error occurred unknown',);
          //           return Center(
          //             child: Text(
          //               'Unknown error',
          //               style: Theme.of(context).textTheme.bodyMedium,
          //             ),
          //           );
          //         }
          //     ),
            allUsers.when(
                data: (users){
                  // final currentUser = sender.user;
                  // final blockedByMe = currentUser?.blockedUsers ?? [];
                  // final filteredUsers = users.where((user) => !blockedByMe.contains(user.uid)).toList();
                  return Column(
                          children: [
                            Text(
                              '${AppStrings.availableUsers} (${users.length})',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child:
                              users.isEmpty
                                  ? Center(
                                child: Text(
                                  AppStrings.emptyUsers,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                                  : ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (_, index) {
                                  final user = users[index];
                                  final otherUser = ref.watch(otherUserFutureProvider(user.uid));
                                  return UsersTile(
                                    userName: user.name!,
                                    userMail: user.email,
                                    onTap: () {
                                      _navigationService.push(ChatView(
                                        userId: sender.user?.uid,
                                        receiverName: user.name,
                                        receiverMail: user.email,
                                        receiverId: user.uid,
                                      userMail: sender.user?.email,
                                      userName: sender.user?.name,
                                        receiverDp: otherUser.value?.profilePic,
                                      ));
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                },
                error: (error, stackTrace){
                  return Center(child: Text(
                    AppStrings.errorGettingUsers,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),);
                },
                loading: () => Center(child: CircularProgressIndicator(color: kCAccentColor,),),
            ),
        ),
      ),
    );
  }
}
