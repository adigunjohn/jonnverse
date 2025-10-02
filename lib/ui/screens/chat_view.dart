import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/jn_textfield.dart';

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
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              GestureDetector(
                  onTap: (){
                    _navigationService.pop();
                  },
                  child: Icon(Icons.arrow_back_rounded, color: kCWhiteColor, size: usersIconSize,),),
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
             Spacer(),
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
              Expanded(child: ListView.builder(
                  itemBuilder: (_,index){
                return Container();
              }))
            ],
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                spacing: 5,
                children: [
                  Expanded(child: JnTextField(
                    controller: _controller,
                  maxLines: 4,
                  hintText: 'Type a message',
                  suffix: Row(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: (){},
                        child: Icon(Icons.attach_file_rounded, color: kCBlueShadeColor, size: settingsIconSize,),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Icon(Icons.camera_alt_outlined, color: kCBlueShadeColor, size: settingsIconSize,),
                      ),
                    ],
                  ),),),
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
          ],
        ),),
    );
  }
}
