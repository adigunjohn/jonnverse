import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
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
          child: Column(
            children: [
              Text(
                '${AppStrings.availableUsers} (4)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 10),
              Expanded(
                child:
                    1 == 2
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
                          itemCount: 4,
                          itemBuilder: (_, index) {
                            return UsersTile(
                              userName: AppStrings.randomName,
                              userMail: AppStrings.randomMail,
                              onTap: () {
                                // _navigationService.push(ChatView(userName: AppStrings.randomName,userMail: AppStrings.randomMail,));
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
