import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/providers/all_users_notifier.dart';
import 'package:jonnverse/providers/chats_notifier.dart';
import 'package:jonnverse/providers/user_notifier.dart';
import 'package:jonnverse/ui/common/date_time_format.dart';
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
    final allChats = ref.watch(allChatsStreamProvider);
    final sender = ref.watch(userProvider);
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
        child: allChats.when(
            data: (allChats) {
              if (allChats.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.noChatsYet,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }
              return Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        radius: Radius.circular(10),
                        controller: _scrollController,
                        child:
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 15, left: 15),
                        //   child:
                        //   ListView(
                        //     children: [
                        //       ChatTile(
                        //           time: '11:56 AM',
                        //           lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                        //           badgeCount: 7,
                        //           userDp: AppStrings.dp1,
                        //           userName: AppStrings.randomMail,
                        //         onTap: (){
                        //         // _navigationService.push(ChatView(userName: AppStrings.randomName,userMail: AppStrings.randomMail,));
                        //         },
                        //       ),
                        //       ChatTile(
                        //           time: '11:56 AM',
                        //           lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                        //           badgeCount: 7,
                        //           userDp: AppStrings.dp1,
                        //           userName: AppStrings.randomMail),
                        //       ChatTile(
                        //           time: '11:56 AM',
                        //           lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                        //           badgeCount: 7,
                        //           userDp: AppStrings.dp1,
                        //           userName: AppStrings.randomMail),
                        //       ChatTile(
                        //           isAI: true,
                        //           time: '11:56 AM',
                        //           badgeCount: 7,
                        //           userName: AppStrings.geminiFromGoogle,
                        //         onTap: (){
                        //           _navigationService.push(GeminiChatView());
                        //         },
                        //       ),
                        //       ChatTile(
                        //           time: '11:56 AM',
                        //           lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                        //           badgeCount: 7,
                        //           userDp: AppStrings.dp1,
                        //           userName: AppStrings.randomMail),
                        //     ]
                        //   ),
                        // ),
                        ListView.builder(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            itemCount: allChats.length,
                            itemBuilder: (context, index){
                              final chat = allChats[index];
                              final otherUser = ref.watch(otherUserFutureProvider(chat.receiverId));
                              // log(otherUser.toString());
                              return ChatTile(
                                time: formatTimeStamp(chat.timestamp.toString()),
                                lastMessage: chat.lastMessage,
                                // lastMessage: 'Hi🖐️, This is a sample message. We welcome you to Jonnverse.',
                                badgeCount: 7,
                                userDp: otherUser.value?.profilePic,
                                userName: chat.receiverName,
                                onTap: (){
                                  _navigationService.push(ChatView(
                                    userId: sender.user?.uid,
                                    receiverName: chat.receiverName,
                                    receiverMail: chat.receiverMail,
                                    receiverId: chat.receiverId,
                                    userMail: sender.user?.email,
                                    userName: sender.user?.name,
                                    receiverDp: otherUser.value?.profilePic,
                                  ));
                                },
                              );
                            }),
                      ),
                    ),
                  ]);
            },
            error: (error, stackTrace) {
              return Center(
                child: Text(
                  AppStrings.errorGettingChats,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
            loading: (){
              return Center(
                child: CircularProgressIndicator(color: kCAccentColor),
              );}
        ),
      ),
    );
  }
}
