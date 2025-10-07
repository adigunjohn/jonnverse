import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/models/metadata.dart';
import 'package:jonnverse/core/repos/chat_repo.dart';
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

final chatStreamProvider = StreamProvider.family<List<JMessage>, ChatIds>((ref, ids) {
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
