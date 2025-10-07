import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/models/metadata.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/ui/common/strings.dart';

class ChatRepo{
  final FirebaseService _firebaseService = locator<FirebaseService>();

  String sortAndJoin(String id1, String id2) {
    List<String> strings = [id1, id2];
    strings.sort();
    return strings.join('+');
  }

  Future<void> sendMessage({required String receiverName, required String senderId, required String receiverId,required JMessage message}) async{
    final chatId = sortAndJoin(senderId, receiverId);
    try{
      await _firebaseService.sendMessage(chatId, message);
      log('${AppStrings.chatRepoLog}Message sent to $receiverName successfully');
    }
    on FirebaseException catch(e){
      log('${AppStrings.chatRepoLog}Firebase Error sending message to $receiverName: ${e.code} - ${e.message}');
      throw Exception('Failed to send message to $receiverName. Please try again.');
    }
    catch(e){
      log('${AppStrings.chatRepoLog}Error sending message to $receiverName: $e');
      throw Exception('Failed to send message to $receiverName. Please try again.');
    }
  }

  // Future<bool> collectionExists(String senderId, String receiverId) async{
  //   final chatId = sortAndJoin(senderId, receiverId);
  //   try{
  //     final value = await _firebaseService.collectionExists(chatId);
  //     return value;
  //   }on FirebaseException catch(e){
  //     log('${AppStrings.chatRepoLog}Firebase Error checking if chat exists:: ${e.code} - ${e.message}');
  //     throw Exception('Failed to check if chat exists. Please try again.');
  //   }
  //   catch(e){
  //     log('${AppStrings.chatRepoLog}Error checking if chat exists: $e');
  //     throw Exception('Failed to check if chat exists. Please try again.');
  //   }
  //   }


  Stream<List<JMessage>> getChatMessages({required String senderId, required String receiverId}) {
    final chatId = sortAndJoin(senderId, receiverId);
    // log('chatId: $chatId');
    try{
     final messages = _firebaseService.getChatMessages(chatId);
      return messages;
    }
    on FirebaseException catch(e){
      log('${AppStrings.chatRepoLog}Firebase Error getting chat messages: ${e.code} - ${e.message}');
      throw Exception('Failed to get chat messages. Please try again.');
    }
    catch(e){
      log('${AppStrings.chatRepoLog}Error getting chat messages: $e');
      throw Exception('Failed to get chat messages. Please try again');
    }
  }

  Stream<List<Metadata>> getAllChats({required String id}) {
    try{
      final messages = _firebaseService.getAllChats(id);
      return messages;
    }
    on FirebaseException catch(e){
      log('${AppStrings.chatRepoLog}Firebase Error getting all chats: ${e.code} - ${e.message}');
      throw Exception('Failed to get all chats. Please try again.');
    }
    catch(e){
      log('${AppStrings.chatRepoLog}Error getting all chats: $e');
      throw Exception('Failed to get all chats. Please try again');
    }
  }



}