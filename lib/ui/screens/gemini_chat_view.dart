import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/enums/download.dart';
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
import 'package:jonnverse/ui/screens/show_image_view.dart';

class GeminiChatView extends ConsumerStatefulWidget {
  const GeminiChatView({super.key, this.userName, this.userMail, this.userId,});
  static const String id = Routes.geminiChatView;
  final String? userName;
  final String? userMail;
  final String? userId;
  @override
  ConsumerState<GeminiChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<GeminiChatView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final SnackBarService _snackBarService = locator<SnackBarService>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final ChatIds _chatIds;
  @override
  void initState() {
    super.initState();
    _chatIds = ChatIds(senderId: widget.userId!, receiverId: AppStrings.geminiUID);
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
                onTap: (){
                  _navigationService.pop();
                  ref.read(chatNotifierProvider.notifier).clearFile();
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
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (x,y){
          ref.read(chatNotifierProvider.notifier).clearFile();
        },
        child: SafeArea(
          child: Stack(
            children: [
              chatMessages.when(
                  data: (chat) {
                    if (chat.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.startConversationWithGemini,
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
                                        isAI: message.senderId == AppStrings.geminiUID,
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
                                          }
                                          _navigationService.push(ShowImageView(image: message.image));
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
                                            isAI: message.senderId == AppStrings.geminiUID,
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
                                              }
                                              _navigationService.push(ShowImageView(image: message.image));
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
                                          );
                                        },
                                      );
                                    }
                                  }
                                  return ChatBubble(
                                    isAI: message.senderId == AppStrings.geminiUID,
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
                isGeminiLoading: chatProvider.isGeminiLoading,
                controller: _controller,
                image: chatProvider.isImagePicked ? chatProvider.filePath : null,
                file: chatProvider.isFilePicked ? chatProvider.fileName : null,
                isSending: chatProvider.isLoading,
                sendTap: () async{
                  final message = JMessage(
                    senderName: widget.userName!,
                    senderId: widget.userId!,
                    senderMail: widget.userMail!,
                    receiverName: AppStrings.gemini,
                    receiverId: AppStrings.geminiUID,
                    receiverMail: '',
                    message: _controller.text.trim(),
                    time: DateTime.now(),
                  );
                  if(_controller.text.trim().isNotEmpty || chatProvider.filePath != null){
                    ref.read(chatNotifierProvider.notifier).sendMessageToAI(_scrollController, message: message,
                    ).then((error){
                      if(error != null){
                        _snackBarService.showSnackBar(message: error);
                        _controller.clear();
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
    );
  }
}
