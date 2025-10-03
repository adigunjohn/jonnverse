import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/chat_bubble.dart';
import 'package:jonnverse/ui/custom_widgets/jn_textfield.dart';
import 'package:jonnverse/ui/screens/show_Image_view.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key, this.userName, this.userMail});
  static const String id = Routes.chatView;
 final String? userName;
 final String? userMail;
  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List messages = [false, true, false, true, false, true, false, true, false, true, false, true, false, true, false, true];
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: Row(
            children: [
              GestureDetector(
                  onTap: (){
                    _navigationService.pop();
                  },
                  child: Icon(Icons.arrow_back_rounded, color: kCWhiteColor, size: usersIconSize,),),
              SizedBox(width: 10),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kCGrey300Color,
                  image: DecorationImage(
                    image: AssetImage(AppStrings.dp1),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Text(
                      widget.userName ?? 'user',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.userMail ?? 'email',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
             // Spacer(),
              SizedBox(width: 10),
              GestureDetector(
                onTap: (){},
                  child: Icon(Icons.block, color: kCWhiteColor, size: usersIconSize,)),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
            children: [
              Expanded(child: Scrollbar(
                radius: Radius.circular(10),
                controller: _scrollController,
                child: ListView.builder(
                  padding: EdgeInsets.only(right: 15, left: 15, bottom: 75),
                  itemCount: messages.length,
                    itemBuilder: (_,index){
                    final message = messages[index];
                 return ChatBubble(isSender: message, onTap: (){
                   _navigationService.push(ShowImageView());
                 },);
                }),
              ))
            ],
                  ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, right: 15, left: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: JnTextField(
                        controller: _controller,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      hintText: AppStrings.typeMessage,
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){},
                                child: Icon(Icons.attach_file, color: kCBlueShadeColor, size: settingsIconSize,),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: (){},
                                child: Icon(Icons.camera_alt_outlined, color: kCBlueShadeColor, size: settingsIconSize,),
                              ),
                            ],
                          ),
                        ),
                      ),),
                    ),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kCBlueShadeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.send, color: kCWhiteColor, size: settingsIconSize,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
