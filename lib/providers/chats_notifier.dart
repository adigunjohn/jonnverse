import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/models/metadata.dart';
import 'package:jonnverse/core/repos/chat_repo.dart';
import 'package:jonnverse/core/services/file_picker_service.dart';
import 'package:jonnverse/providers/auth_notifier.dart';

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

final chatMessagesStreamProvider = StreamProvider.family<List<JMessage>, ChatIds>((ref, ids) {
  final repo = ref.watch(chatRepoProvider);
  return repo.getChatMessages(senderId: ids.senderId, receiverId: ids.receiverId);
});

final allChatsStreamProvider = StreamProvider<List<Metadata>>((ref){
  final repo = ref.watch(chatRepoProvider);
  final auth = ref.watch(authProvider);
  final userId = auth.user?.uid;
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
  final String? filePath;
  final String? fileName;
  final bool isLoading;
  final bool isImagePicked;
  final bool isFilePicked;
  ChatState({this.filePath, this.fileName, this.isLoading = false, this.isFilePicked = false, this.isImagePicked = false});
 ChatState copyWith({String? filePath, String? fileName, bool? isLoading, bool? isImagePicked, bool? isFilePicked}){
    return ChatState(
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      isLoading: isLoading ?? this.isLoading,
      isImagePicked: isImagePicked ?? this.isImagePicked,
      isFilePicked: isFilePicked ?? this.isFilePicked,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  final ChatRepo _chatRepo = locator<ChatRepo>();
  final FilePickerService _filePickerService = locator<FilePickerService>();

  @override
  ChatState build() => ChatState();

  Future<String?> sendMessage({required JMessage message}) async {
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
          image: imageUrl
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
          file: fileUrl
        );
      }
      await _chatRepo.sendMessage(message: jmessage ?? message);
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
      state = state.copyWith(filePath: result.path, fileName: result.name, isImagePicked: true, isFilePicked: false);
    }
  }

  Future<void> pickFile()async{
    final result = await _filePickerService.pickFile();
    if(result != null && result.isNotEmpty){
      final file = result.first;
      state = state.copyWith(filePath: file.path, fileName: file.name, isFilePicked: true, isImagePicked: false);
    }
  }

  void clearFile(){
    state = state.copyWith(filePath: null, fileName: null, isFilePicked: false, isImagePicked: false);
  }
}
 //final chatNotifierProvider = NotifierProvider<ChatNotifier, bool>(() => ChatNotifier());
 final chatNotifierProvider = NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);