import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/services/dialog_service.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/core/services/snackbar_service.dart';
import 'package:jonnverse/providers/chats_notifier.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/chat_bubble.dart';
import 'package:jonnverse/ui/custom_widgets/chat_field.dart';
import 'package:jonnverse/ui/custom_widgets/progress_indicator.dart';
import 'package:jonnverse/ui/screens/show_image_view.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({
    super.key,
    this.receiverName,
    this.receiverMail,
    this.receiverId,
    this.userId,
    this.userMail,
    this.userName,
  });
  static const String id = Routes.chatView;
  final String? receiverMail;
  final String? receiverId;
  final String? userId;
  final String? userName;
  final String? userMail;
  final String? receiverName;
  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final SnackBarService _snackBarService = locator<SnackBarService>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final ChatIds _chatIds;
  @override
  void initState() {
    super.initState();
    _chatIds = ChatIds(senderId: widget.userId!, receiverId: widget.receiverId!);
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatMessagesStreamProvider(_chatIds));
    final chatProvider = ref.watch(chatNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _navigationService.pop();
                  ref.read(chatNotifierProvider.notifier).clearFile();
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: kCWhiteColor,
                  size: usersIconSize,
                ),
              ),
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
                      widget.receiverName!,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.receiverMail!,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.copyWith(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Spacer(),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.block,
                  color: kCWhiteColor,
                  size: usersIconSize,
                ),
              ),
            ],
          ),
        ),
      ),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (x,y){
          ref.read(chatNotifierProvider.notifier).clearFile();
        },
        child: SafeArea(
          child: ProgressHud(
            loading: chatProvider.isLoading,
            child: Stack(
              children: [
                // StreamBuilder(
                //     stream: ChatRepo().getChatMessages(senderId: widget.userId!, receiverId: widget.receiverId!),
                //     builder: (context, snapshot){
                //       if(snapshot.connectionState == ConnectionState.waiting){
                //         return Center(child: CircularProgressIndicator(color: kCAccentColor,),);
                //       }
                //       if(snapshot.hasData){
                //         final chat = snapshot.data!;
                //         if (chat.isEmpty) {
                //           return Center(
                //             child: Text(
                //               'No messages yet',
                //               style: Theme.of(context).textTheme.bodySmall,
                //               maxLines: 2,
                //               textAlign: TextAlign.center,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           );
                //         }
                //         return Column(
                //           children: [
                //             Expanded(
                //               child: Scrollbar(
                //                 radius: Radius.circular(10),
                //                 controller: _scrollController,
                //                 child: ListView.builder(
                //                   padding: EdgeInsets.only(
                //                     right: 15,
                //                     left: 15,
                //                     bottom: 75,
                //                   ),
                //                   itemCount: chat.length,
                //                   itemBuilder: (_, index) {
                //                     final message = chat[index];
                //                     return ChatBubble(
                //                       isUser: message.senderId == widget.userId,
                //                       message: message.message,
                //                       file: null,
                //                       // image: AppStrings.dp,
                //                       time: message.time.toString(),
                //                       onTap: () {
                //                         _navigationService.push(ShowImageView());
                //                       },
                //                     );
                //                   },
                //                 ),
                //               ),
                //             ),
                //           ],
                //         );
                //       }
                //       if(snapshot.hasError){
                //         log('Error occurred while fetching all the available messages',);
                //         return Center(
                //           child: Text(
                //             'Failed to fetch all the available messages',
                //             style: Theme.of(context).textTheme.bodyMedium,
                //           ),
                //         );
                //       }
                //       log('Error occurred unknown',);
                //       return Center(
                //         child: Text(
                //           'Unknown error',
                //           style: Theme.of(context).textTheme.bodyMedium,
                //         ),
                //       );
                //     }
                // ),
                chatMessages.when(
                  data: (chat) {
                    if (chat.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.startConversation,
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
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Scrollbar(
                              radius: Radius.circular(10),
                              controller: _scrollController,
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  right: 15,
                                  left: 15,
                                  bottom: 75,
                                ),
                                itemCount: chat.length,
                                controller: _scrollController,
                                reverse: true,
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  final message = chat.reversed.toList()[index];
                                  return ChatBubble(
                                    isUser: message.senderId == widget.userId,
                                    message: message.message,
                                    file: message.file,
                                    image: message.image,
                                    // image: AppStrings.dp,
                                    time: message.time.toString(),
                                    onTap: () {
                                      _navigationService.push(ShowImageView(image: message.image,));
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        AppStrings.errorGettingMessages,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  },
                  loading: (){
                    return Center(
                        child: CircularProgressIndicator(color: kCAccentColor),
                      );}
                ),
                ChatField(
                  controller: _controller,
                  image: chatProvider.isImagePicked ? chatProvider.filePath : null,
                  file: chatProvider.isFilePicked ? chatProvider.fileName : null,
                  sendTap: () async{
                    final message = JMessage(
                      senderName: widget.userName!,
                      senderId: widget.userId!,
                      senderMail: widget.userMail!,
                      receiverName: widget.receiverName!,
                      receiverId: widget.receiverId!,
                      receiverMail: widget.receiverMail!,
                      message: _controller.text.trim(),
                      time: DateTime.now(),
                    );
                    if(_controller.text.trim().isNotEmpty || chatProvider.filePath != null){
                      ref.read(chatNotifierProvider.notifier).sendMessage(_scrollController, message: message,
                      ).then((error){
                        if(error != null){
                          _snackBarService.showSnackBar(message: error);
                        } else {
                          _controller.clear();
                        }
                      });
                    }
                  },
                  cameraTap: () {
                    _dialogService.showBottom(context,
                      title: AppStrings.pickImage,
                      subtitle: AppStrings.pickImageSub,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            _navigationService.pop();
                            ref.read(chatNotifierProvider.notifier).pickImage(ImageSource.camera);
                          },
                          icon: Icon(Icons.camera_alt_rounded, color: kCGreyColor, size: chatIconSize,),
                        ),
                        IconButton(
                          onPressed: () {
                           _navigationService.pop();
                            ref.read(chatNotifierProvider.notifier).pickImage(ImageSource.gallery);
                          },
                          icon: Icon(Icons.photo_library_rounded, color: kCGreyColor, size: chatIconSize,),
                        ),
                      ],
                    ),);
                  },
                  fileTap: ref.read(chatNotifierProvider.notifier).pickFile,
                  onDeleteFile: ref.read(chatNotifierProvider.notifier).clearFile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
