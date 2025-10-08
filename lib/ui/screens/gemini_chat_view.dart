import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/chat_bubble.dart';
import 'package:jonnverse/ui/custom_widgets/chat_field.dart';
import 'package:jonnverse/ui/screens/show_image_view.dart';

class GeminiChatView extends ConsumerStatefulWidget {
  const GeminiChatView({super.key, this.userName, this.userMail});
  static const String id = Routes.geminiChatView;
  final String? userName;
  final String? userMail;
  @override
  ConsumerState<GeminiChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<GeminiChatView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List messages = [false, true, false, true, false,];
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
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kCGrey300Color,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SvgPicture.asset(AppStrings.geminiImage, height: 30, width: 30,)),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppStrings.gemini,
                  style: Theme.of(context).textTheme.displayLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Spacer(),
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
                        return ChatBubble(
                          isUser: message,
                          message: 'Hey, I am Jonny',
                          file: null,
                          // image: AppStrings.dp,
                          time: '',
                          onTap: (){
                            _navigationService.push(ShowImageView());
                          },);
                      }),
                ))
              ],
            ),
            ChatField(
              controller: _controller,
              // fileVisible: true,
              // image: AppStrings.dp,
              file: 'my resume.pdf',
              sendTap: (){},
              cameraTap: (){},
              fileTap: (){},
              onDeleteFile: (){},
            ),
          ],
        ),
      ),
    );
  }
}
