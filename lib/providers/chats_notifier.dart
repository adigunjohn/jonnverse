import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/enums/download.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/models/metadata.dart';
import 'package:jonnverse/core/repos/chat_repo.dart';
import 'package:jonnverse/core/repos/connectivity_repo.dart';
import 'package:jonnverse/core/repos/file_repo.dart';
import 'package:jonnverse/core/services/file_picker_service.dart';
import 'package:jonnverse/providers/user_notifier.dart';
import 'package:jonnverse/ui/common/strings.dart';

class ChatIds {
  final String senderId;
  final String receiverId;
  const ChatIds({required this.senderId, required this.receiverId});

  // String get chatId {
  //   final parts = [senderId, receiverId]..sort();
  //   return parts.join('+');
  // }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChatIds &&
              runtimeType == other.runtimeType &&
              senderId == other.senderId &&
              receiverId == other.receiverId;

  @override
  int get hashCode => senderId.hashCode ^ receiverId.hashCode;

  @override
  String toString() => 'ChatIds($senderId,$receiverId)';
}

final chatRepoProvider = Provider<ChatRepo>((ref) => locator<ChatRepo>());
final fileRepoProvider = Provider<FileRepo>((ref) => locator<FileRepo>());

final chatMessagesStreamProvider = StreamProvider.family<List<JMessage>, ChatIds>((ref, ids) {
  final repo = ref.watch(chatRepoProvider);
  return repo.getChatMessages(senderId: ids.senderId, receiverId: ids.receiverId);
});

final allChatsStreamProvider = StreamProvider<List<Metadata>>((ref){
  final repo = ref.watch(chatRepoProvider);
  final user = ref.watch(userProvider);
  final userId = user.user?.uid;
  if (userId == null) {
    log('[Chats Notifier] User uid provided is null, returning empty list');
    return Stream.value(<Metadata>[]);
  }
  return repo.getAllChats(id: userId);
});

// final chatExistFutureProvider = FutureProvider.family<bool, ChatIds>((ref, ids) {
//   final repo = ref.watch(chatRepoProvider);
//   return repo.collectionExists(ids.senderId,ids.receiverId);
// });



class ChatState{
  final Map<String, Download> downloadStates;
  final String? filePath;
  final String? fileName;
  final bool isLoading;
  final bool isGeminiLoading;
  final bool isImagePicked;
  final bool isFilePicked;
  final bool isMessagePressed;
  final String? messageContent;
  final String? fileContent;
  ChatState({this.downloadStates = const {},this.fileContent, this.messageContent, this.isMessagePressed = false, this.filePath, this.fileName, this.isLoading = false, this.isGeminiLoading = false, this.isFilePicked = false, this.isImagePicked = false,});
 ChatState copyWith({String? filePath,String? fileContent, String? messageContent, String? fileName, bool? isMessagePressed, bool? isLoading, bool? isGeminiLoading, bool? isImagePicked, bool? isFilePicked, Map<String, Download>? downloadStates,}){
    return ChatState(
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      isLoading: isLoading ?? this.isLoading,
      isGeminiLoading: isGeminiLoading ?? this.isGeminiLoading,
      isImagePicked: isImagePicked ?? this.isImagePicked,
      isFilePicked: isFilePicked ?? this.isFilePicked,
      downloadStates: downloadStates ?? this.downloadStates,
      isMessagePressed: isMessagePressed ?? this.isMessagePressed,
      messageContent: messageContent ?? this.messageContent,
      fileContent: fileContent ?? this.fileContent,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  final ChatRepo _chatRepo = locator<ChatRepo>();
  final FilePickerService _filePickerService = locator<FilePickerService>();
  final FileRepo _fileRepo = locator<FileRepo>();
  final ConnectivityRepo _connectivityRepo = locator<ConnectivityRepo>();

  @override
  ChatState build() => ChatState(downloadStates: _chatRepo.getDownloadStatesFromLocalStorage());

  Future<String?> sendMessage(ScrollController scrollController, {required JMessage message}) async {
    if(await _connectivityRepo.hasInternet() == false) return AppStrings.noInternet;
    state = state.copyWith(isLoading: true);
    JMessage? jmessage;
    try {
      if(state.isImagePicked && state.filePath != null){
        final imageUrl = await _chatRepo.uploadFile(filename: state.fileName!, file: File(state.filePath!));
        jmessage = JMessage(
          senderId: message.senderId,
          senderName: message.senderName,
          senderMail: message.senderMail,
          receiverId: message.receiverId,
          receiverName: message.receiverName,
          receiverMail: message.receiverMail,
          time: message.time,
          message: message.message,
          fileName: state.fileName,
          image: imageUrl,
          filePath: state.filePath,
        );
      } else if(state.isFilePicked && state.filePath != null){
        final fileUrl = await _chatRepo.uploadFile(filename: state.fileName!, file: File(state.filePath!));
        jmessage = JMessage(
          senderId: message.senderId,
          senderName: message.senderName,
          senderMail: message.senderMail,
          receiverId: message.receiverId,
          receiverName: message.receiverName,
          receiverMail: message.receiverMail,
          time: message.time,
          message: message.message,
          file: fileUrl,
          fileName: state.fileName,
          filePath: state.filePath,
        );
      }
      await _chatRepo.sendMessage(message: jmessage ?? message);
      clearFile();
      scrollToBottom(scrollController);
      log('Message sent to ${message.receiverName} successfully');
      return null;
    } catch (e) {
      log('Error sending message to ${message.receiverName}: $e');
      return e.toString().replaceFirst('Exception: ', '');
    }finally{
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> pickImage(ImageSource source)async{
    final result = await _filePickerService.pickImage(source: source);
    if(result != null){
      clearFile();
      state = state.copyWith(filePath: result.path, fileName: result.name, isImagePicked: true, isFilePicked: false);
    }
  }

  Future<void> pickFile()async{
    final result = await _filePickerService.pickFile();
    if(result != null && result.isNotEmpty){
      final file = result.first;
      clearFile();
      state = state.copyWith(filePath: file.path, fileName: file.name, isFilePicked: true, isImagePicked: false);
    }
  }

  void clearFile(){
    state = state.copyWith(filePath: null, fileName: null, isFilePicked: false, isImagePicked: false);
  }

  void scrollToBottom(ScrollController scrollController){
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(scrollController.hasClients){
        scrollController.animateTo(
          0.0,
          // scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<String?> downloadFile(String fileUrl, String filename,{ProgressCallback? onProgress, CancelToken? cancelToken,})async{
    if(await _connectivityRepo.hasInternet() == false){
      final newStates = Map<String, Download>.from(state.downloadStates);
      newStates[fileUrl] = Download.failed;
      state = state.copyWith(downloadStates: newStates);
      await _chatRepo.updateDownloadStatesToLocalStorage(urlKey: fileUrl, downloadState: Download.failed.name);
        return AppStrings.noInternet;
    }
    final newStates = Map<String, Download>.from(state.downloadStates);
    newStates[fileUrl] = Download.downloading;
    state = state.copyWith(downloadStates: newStates);
    await _chatRepo.updateDownloadStatesToLocalStorage(urlKey: fileUrl, downloadState: Download.downloading.name);
    try{
      _fileRepo.downloadFile(fileUrl, filename, onProgress: onProgress, cancelToken: cancelToken);
      final finalStates = Map<String, Download>.from(state.downloadStates);
      finalStates[fileUrl] = Download.downloaded;
      state = state.copyWith(downloadStates: finalStates);
      await _chatRepo.updateDownloadStatesToLocalStorage(urlKey: fileUrl, downloadState: Download.downloaded.name);
      return null;
    }catch(e){
      final finalStates = Map<String, Download>.from(state.downloadStates);
      finalStates[fileUrl] = Download.failed;
      state = state.copyWith(downloadStates: finalStates);
      await _chatRepo.updateDownloadStatesToLocalStorage(urlKey: fileUrl, downloadState: Download.failed.name);
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<bool> doesFileExist(String fileName) async {
    return await _fileRepo.fileExists(fileName);
  }

  Future<String> getImageDownloadedPath(String fileName) async {
    return await _fileRepo.openImage(fileName);
  }

  Future<String?> sendMessageToAI(ScrollController scrollController, {required JMessage message}) async {
    if(await _connectivityRepo.hasInternet() == false) return AppStrings.noInternet;
    state = state.copyWith(isLoading: true);
    JMessage? jmessage;
    try {
      if(state.isImagePicked && state.filePath != null){
        final imageUrl = await _chatRepo.uploadFile(filename: state.fileName!, file: File(state.filePath!));
        jmessage = JMessage(
          senderId: message.senderId,
          senderName: message.senderName,
          senderMail: message.senderMail,
          receiverId: message.receiverId,
          receiverName: message.receiverName,
          receiverMail: message.receiverMail,
          time: message.time,
          message: message.message,
          fileName: state.fileName,
          image: imageUrl,
          filePath: state.filePath,
        );
      } else if(state.isFilePicked && state.filePath != null){
        final fileUrl = await _chatRepo.uploadFile(filename: state.fileName!, file: File(state.filePath!));
        jmessage = JMessage(
          senderId: message.senderId,
          senderName: message.senderName,
          senderMail: message.senderMail,
          receiverId: message.receiverId,
          receiverName: message.receiverName,
          receiverMail: message.receiverMail,
          time: message.time,
          message: message.message,
          file: fileUrl,
          fileName: state.fileName,
          filePath: state.filePath,
        );
      }
      await _chatRepo.sendMessageToAI(message: jmessage ?? message);
      scrollToBottom(scrollController);
      log('Message sent to ${message.receiverName} successfully');
      state = state.copyWith(isLoading: false);
      state = state.copyWith(isGeminiLoading: true);
      final chatIds = ChatIds(senderId: message.senderId, receiverId: message.receiverId);
      final historySnapshot = await ref.read(chatMessagesStreamProvider(chatIds).future);
      await _chatRepo.receiveMessageFromAI(
        message: message,
        file: state.filePath != null ? File(state.filePath!) : null,
        messages: historySnapshot,
      );
      clearFile();
      scrollToBottom(scrollController);
      return null;
    } catch (e) {
      log('Error sending message to ${message.receiverName}: $e');
      return e.toString().replaceFirst('Exception: ', '');
    }finally{
      state = state.copyWith(isGeminiLoading: false);
    }
  }

  void updateMessagePressed({required bool value,String? message,String? file}){
    state = state.copyWith(isMessagePressed: value, messageContent: message, fileContent: file);
  }

}
 //final chatNotifierProvider = NotifierProvider<ChatNotifier, bool>(() => ChatNotifier());
 final chatNotifierProvider = NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);





//// Use addPostFrameCallback to ensure the notifier is built before you call it.
// WidgetsBinding.instance.addPostFrameCallback((_) {
//   ref.read(chatNotifierProvider.notifier).initStateFromStorage();
// });