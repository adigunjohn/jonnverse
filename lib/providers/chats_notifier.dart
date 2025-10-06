import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/repos/chat_repo.dart';

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

// final chatExistFutureProvider = FutureProvider.family<bool, ChatIds>((ref, ids) {
//   final repo = ref.watch(chatRepoProvider);
//   return repo.collectionExists(ids.senderId,ids.receiverId);
// });
