import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/chat_tile.dart';
import 'package:jonnverse/ui/screens/chat_view.dart';
import 'package:jonnverse/ui/screens/gemini_chat_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  static const String id = Routes.homeView;

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}
class _HomeViewState extends ConsumerState<HomeView> {
  final ScrollController _scrollController = ScrollController();
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.jonnverse,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kCAccentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          _navigationService.pushNamed(GeminiChatView.id);
        },
        child: Icon(CupertinoIcons.sparkles,color: kCOnAccentColor, size: fabIconSize,),
      ),
      body: SafeArea(
        child: 1 == 2
            ? Center(
              child: Text(
                AppStrings.noChatsYet,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            )
            : Column(
            children: [
              Expanded(
                child: Scrollbar(
                  radius: Radius.circular(10),
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: ListView(
                      children: [
                        ChatTile(
                            time: '11:56 AM',
                            lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                            badgeCount: 7,
                            userDp: AppStrings.dp1,
                            userName: AppStrings.randomMail,
                          onTap: (){
                           _navigationService.push(ChatView(userName: AppStrings.randomName,userMail: AppStrings.randomMail,));
                          },
                        ),
                        ChatTile(
                            time: '11:56 AM',
                            lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                            badgeCount: 7,
                            userDp: AppStrings.dp1,
                            userName: AppStrings.randomMail),
                        ChatTile(
                            time: '11:56 AM',
                            lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                            badgeCount: 7,
                            userDp: AppStrings.dp1,
                            userName: AppStrings.randomMail),
                        ChatTile(
                            isAI: true,
                            time: '11:56 AM',
                            badgeCount: 7,
                            userName: AppStrings.gemini),
                        ChatTile(
                            time: '11:56 AM',
                            lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                            badgeCount: 7,
                            userDp: AppStrings.dp1,
                            userName: AppStrings.randomMail),
                      ]
                    ),
                  )
                  // ListView.builder(
                  //   padding: const EdgeInsets.only(right: 15, left: 15),
                  //   itemCount: 5,
                  //     itemBuilder: (context, index){
                  //    return ChatTile(
                  //        time: '11:56 AM',
                  //        lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                  //        badgeCount: 7,
                  //        userDp: AppStrings.dp1,
                  //        userName: AppStrings.randomMail);
                  // }),
                ),
              ),
        ]),
      ),
    );
  }
}
