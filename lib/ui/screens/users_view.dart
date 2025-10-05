import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/providers/all_users_notifier.dart';
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
            allUsers.when(
                data: (users){
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
                                  return UsersTile(
                                    userName: user.name!,
                                    userMail: user.email,
                                    onTap: () {
                                      _navigationService.push(ChatView(
                                        userName: user.name,
                                        userMail: user.email,));
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                },
                error: (error, stackTrace){
                  log('Error occurred while fetching all the available users: $error $stackTrace');
                  return Center(child: Text(
                    'Failed to fetch all the available users',
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
