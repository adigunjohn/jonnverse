import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/enums/download.dart';
import 'package:jonnverse/core/models/in_chat_gemini_message.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/services/dialog_service.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/core/services/snackbar_service.dart';
import 'package:jonnverse/providers/all_users_notifier.dart';
import 'package:jonnverse/providers/chats_notifier.dart';
import 'package:jonnverse/providers/in_chat_gemini_notifier.dart';
import 'package:jonnverse/providers/user_notifier.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/chat_bubble.dart';
import 'package:jonnverse/ui/custom_widgets/chat_field.dart';
import 'package:jonnverse/ui/custom_widgets/in_chat_gemini.dart';
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
    this.receiverDp,
  });
  static const String id = Routes.chatView;
  final String? receiverMail;
  final String? receiverId;
  final String? userId;
  final String? userName;
  final String? userMail;
  final String? receiverName;
  final String? receiverDp;
  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final SnackBarService _snackBarService = locator<SnackBarService>();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _aiController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _aiScrollController = ScrollController();

  late final ChatIds _chatIds;
  // late final String _otherUserId;
  @override
  void initState() {
    super.initState();
    _chatIds = ChatIds(senderId: widget.userId!, receiverId: widget.receiverId!);
    // _otherUserId = widget.receiverId!;
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
    _aiController.dispose();
    _aiScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatMessagesStreamProvider(_chatIds));
    final chatProvider = ref.watch(chatNotifierProvider);
    final inChatGeminiProvider = ref.watch(inChatGeminiNotifierProvider);
    final currentUser = ref.watch(userProvider);
    //final otherUser = ref.watch(otherUserFutureProvider(_otherUserId));
    final otherUser = ref.watch(otherUserFutureProvider(widget.receiverId!));

    final iBlockedUser = currentUser.user?.blockedUsers?.contains(widget.receiverId) ?? false;
    final userBlockedMe = otherUser.when(
    data: (otherUser) => otherUser?.blockedUsers?.contains(widget.userId) ?? false,
    loading: (){return false;}, error: (e, s) => false);

    final isBlocked = iBlockedUser || userBlockedMe;

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
                  ref.read(inChatGeminiNotifierProvider.notifier).closeMessagePressed();
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
                  image: widget.receiverDp != null && widget.receiverDp != ''? DecorationImage(image: CachedNetworkImageProvider(widget.receiverDp!), fit: BoxFit.cover) : null,
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
                onTap: () {
                  _dialogService.showAlertDialog(context,
                      title: iBlockedUser ? 'Unblock User' : 'Block User',
                      subtitle: iBlockedUser
                          ? 'Are you sure you want to unblock ${widget.receiverName}?'
                          : 'Block ${widget.receiverName}? You will no longer be able to send or receive messages.',
                      actions: [
                        TextButton(onPressed: _navigationService.pop, child: Text('Cancel')),
                        TextButton(
                            onPressed: () async{
                              _navigationService.pop();
                             final error = await ref.read(userProvider.notifier).toggleBlockUser(widget.receiverId!);
                             if(error != null){_snackBarService.showSnackBar(message: error);}
                             else{
                               _navigationService.pop();
                               _snackBarService.showSnackBar(message: 'Successfully blocked ${widget.receiverName}');
                             }
                            },
                            child: Text(iBlockedUser ? 'Unblock' : 'Block', style: TextStyle(color: kCRedColor))
                        ),
                      ]
                  );
                },
                child: Icon(
                  Icons.block,
                  color: iBlockedUser ? kCRedColor : kCWhiteColor,
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
          ref.read(inChatGeminiNotifierProvider.notifier).closeMessagePressed();
        },
        child: SafeArea(
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
                        final chatRead = ref.read(chatNotifierProvider.notifier);

                    final String? fileUrl = message.file ?? message.image;

                    if (fileUrl != null) {
                      Download downloadState = Download.download;

                      if (chatProvider.downloadStates.containsKey(fileUrl)) {
                        downloadState = chatProvider.downloadStates[fileUrl]!;
                        return ChatBubble(
                          isUser: message.senderId == widget.userId,
                          message: message.message,
                          file: message.file,
                          fileName: message.fileName,
                          image: message.image,
                          filePath: message.filePath,
                          time: message.time.toString(),
                          download: downloadState,
                          onDownloadTap: () async{
                            if (downloadState != Download.downloaded && downloadState != Download.downloading) {
                             final error = await chatRead.downloadFile(fileUrl, message.fileName!);
                              if(error != null)_snackBarService.showSnackBar(message: error);
                            }
                          },
                          onImageTap: () async{
                            if (downloadState == Download.downloaded) {
                              final path = await ref.read(fileRepoProvider).openImage(message.fileName!);
                              _navigationService.push(ShowImageView(image: path, isDownloaded: true,));
                            } else if(message.senderId == widget.userId){
                              _navigationService.push(ShowImageView(image: message.filePath,isUser: true,));
                              // _navigationService.push(ShowImageView(image: message.image,));
                            }
                            // _navigationService.push(ShowImageView(image: message.image));
                          },
                          onFileTap: () async {
                            if (downloadState == Download.downloaded) {
                              await ref.read(fileRepoProvider).openFile(message.fileName!);
                            } else if(message.senderId == widget.userId){
                              await ref.read(fileRepoProvider).openFilex(message.filePath!);
                            } else {
                            _dialogService.showAlertDialog(context, title: 'File Not Downloaded', subtitle: 'First download the file you wanna open.');
                            }
                          },
                            onMessagePress: ()async{
                              if(downloadState == Download.downloaded){
                                final path = await ref.read(fileRepoProvider).openImage(message.fileName!);
                                ref.read(inChatGeminiNotifierProvider.notifier).updateMessagePressed(
                                  value: true,
                                  message: message.message,
                                  file: message.image == null && message.file != null ? path : null,
                                  imageFile: message.image != null && message.file == null ? path : null,
                                  fileName: message.image == null && message.file != null ? message.fileName : null,
                                );
                              }
                              else if(message.senderId == widget.userId){
                                ref.read(inChatGeminiNotifierProvider.notifier).updateMessagePressed(
                                  value: true,
                                  message: message.message,
                                  file: message.image == null && message.file != null ? message.filePath : null,
                                  imageFile: message.image != null && message.file == null ? message.filePath : null,
                                  fileName: message.image == null && message.file != null ? message.fileName : null,
                                );
                              }
                              else {
                                _dialogService.showAlertDialog(context, title: 'File Not Downloaded', subtitle: 'First download the file you wanna open.');
                              }
                            }
                        );
                      } else {
                        return FutureBuilder<bool>(
                          future: chatRead.doesFileExist(message.fileName!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState != ConnectionState.done) {
                              downloadState = Download.download;
                            } else if (snapshot.data == true) {
                              downloadState = Download.downloaded;
                            }
                            return ChatBubble(
                              isUser: message.senderId == widget.userId,
                              message: message.message,
                              file: message.file,
                              fileName: message.fileName,
                              image: message.image,
                              filePath: message.filePath,
                              time: message.time.toString(),
                              download: downloadState,
                              onDownloadTap: () async{
                                if (downloadState != Download.downloaded && downloadState != Download.downloading) {
                                 final error = await chatRead.downloadFile(fileUrl, message.fileName!);
                                 if(error != null)_snackBarService.showSnackBar(message: error);
                                }
                              },
                              onImageTap: () async{
                                if (downloadState == Download.downloaded) {
                                  final path = await ref.read(fileRepoProvider).openImage(message.fileName!);
                                  _navigationService.push(ShowImageView(image: path,isDownloaded: true,));
                                } else if(message.senderId == widget.userId){
                                   _navigationService.push(ShowImageView(image: message.filePath,isUser: true,));
                                   // _navigationService.push(ShowImageView(image: message.image,));
                                }
                                // _navigationService.push(ShowImageView(image: message.image));
                              },
                              onFileTap: () async {
                                if (downloadState == Download.downloaded) {
                                  await ref.read(fileRepoProvider).openFile(message.fileName!);
                                } else if(message.senderId == widget.userId){
                                  await ref.read(fileRepoProvider).openFilex(message.filePath!);
                                } else {
                                  _dialogService.showAlertDialog(context, title: 'File Not Downloaded', subtitle: 'First download the file you wanna open.');
                                }
                              },
                              onMessagePress: ()async{
                                if(downloadState == Download.downloaded){
                                  final path = await ref.read(fileRepoProvider).openImage(message.fileName!);
                                  ref.read(inChatGeminiNotifierProvider.notifier).updateMessagePressed(
                                      value: true,
                                      message: message.message,
                                      file: message.image == null && message.file != null ? path : null,
                                    imageFile: message.image != null && message.file == null ? path : null,
                                    fileName: message.image == null && message.file != null ? message.fileName : null,
                                  );
                                }
                                else if(message.senderId == widget.userId){
                                  ref.read(inChatGeminiNotifierProvider.notifier).updateMessagePressed(
                                    value: true,
                                    message: message.message,
                                    file: message.image == null && message.file != null ? message.filePath : null,
                                    imageFile: message.image != null && message.file == null ? message.filePath : null,
                                    fileName: message.image == null && message.file != null ? message.fileName : null,
                                  );
                                }
                                else {
                                  _dialogService.showAlertDialog(context, title: 'File Not Downloaded', subtitle: 'First download the file you wanna open.');
                                }
                              }
                            );
                          },
                        );
                      }
                    }

                    return ChatBubble(
                      isUser: message.senderId == widget.userId,
                      message: message.message,
                      file: null,
                      fileName: null,
                      image: null,
                      filePath: null,
                      time: message.time.toString(),
                      download: Download.download,
                      onDownloadTap: null,
                      onImageTap: null,
                      onFileTap: null,
                      onMessagePress: ()=> ref.read(inChatGeminiNotifierProvider.notifier).updateMessagePressed(value: true,message: message.message,fileName: null,imageFile: null,file: null,),
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
              isBlocked ? Padding(
                padding: const EdgeInsets.only(bottom: 15.0, right: 15, left: 15),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        iBlockedUser
                            ? 'You have blocked this user. Unblock them to send messages.'
                            : 'You can no longer reply to this conversation.',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
              ) :
              ChatField(
                controller: _controller,
                image: chatProvider.isImagePicked ? chatProvider.filePath : null,
                file: chatProvider.isFilePicked ? chatProvider.fileName : null,
                isSending: chatProvider.isLoading,
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
              Visibility(
                // visible: true,
                visible: inChatGeminiProvider.isMessagePressed,
                  child: InChatGemini(
                    onCloseTap: ref.read(inChatGeminiNotifierProvider.notifier).closeMessagePressed,
                    controller: _aiController,
                    scrollController: _aiScrollController,
                    message: inChatGeminiProvider.messageContent,
                    file: inChatGeminiProvider.fileContent,
                    fileName: inChatGeminiProvider.fileNameContent,
                    image: inChatGeminiProvider.imageFileContent,
                    loading: inChatGeminiProvider.contentLoading,
                    messages: inChatGeminiProvider.messages.reversed.toList(),
                    onSendTap: (prompt) async {
                      if(prompt != null || _aiController.text.trim().isNotEmpty){
                        final imageCaption = inChatGeminiProvider.messageContent != null && inChatGeminiProvider.imageFileContent != null ? inChatGeminiProvider.messageContent : '';
                        final fileCaption = inChatGeminiProvider.messageContent != null && inChatGeminiProvider.fileContent != null ? inChatGeminiProvider.messageContent : '';
                        final caption = inChatGeminiProvider.imageFileContent == null && inChatGeminiProvider.fileContent == null ? inChatGeminiProvider.messageContent : '';
                        final initialMessage = InChatGeminiMessage(
                            message: '$caption$imageCaption$fileCaption "${(prompt ?? _aiController.text)}"',
                            isUser: true,
                            filepath: inChatGeminiProvider.imageFileContent ?? inChatGeminiProvider.fileContent
                        );
                        final otherMessage = InChatGeminiMessage(message: (prompt ?? _aiController.text), isUser: true,);
                        final message = inChatGeminiProvider.conversationStarted ? otherMessage : initialMessage;
                        final result = await ref.read(inChatGeminiNotifierProvider.notifier).promptGemini(message, _aiScrollController);
                        if(result != null) _snackBarService.showSnackBar(message: result);
                        if(result == null) _aiController.clear();
                      }
                    },
                  ),),
            ],
          ),
        ),
      ),
    );
  }
}
