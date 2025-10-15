import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/enums/download.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/models/metadata.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/core/services/supabase_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepo{
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final SupabaseService _supabaseService = locator<SupabaseService>();
  final HiveService _hiveService = locator<HiveService>();


  String sortAndJoin(String id1, String id2) {
    List<String> strings = [id1, id2];
    strings.sort();
    return strings.join('+');
  }

  Future<void> sendMessage({required JMessage message}) async{
    final chatId = sortAndJoin(message.senderId, message.receiverId);
    try{
      await _firebaseService.sendMessage(chatId, message);
      log('${AppStrings.chatRepoLog}Message sent to ${message.receiverName} successfully');
    }
    on FirebaseException catch(e){
      log('${AppStrings.chatRepoLog}Firebase Error sending message to ${message.receiverName}: ${e.code} - ${e.message}');
      throw Exception('Failed to send message to ${message.receiverName}. Please try again.');
    }
    catch(e){
      log('${AppStrings.chatRepoLog}Error sending message to ${message.receiverName}: $e');
      throw Exception('Failed to send message to ${message.receiverName}. Please try again.');
    }
  }

  Future<void> sendMessageToAI({required JMessage message}) async{
    final chatId = sortAndJoin(message.senderId, message.receiverId);
    try{
      await _firebaseService.sendMessageToAI(chatId, message);
      log('${AppStrings.chatRepoLog}Message sent to ${message.receiverName} successfully');
    }
    on FirebaseException catch(e){
      log('${AppStrings.chatRepoLog}Firebase Error sending message to ${message.receiverName}: ${e.code} - ${e.message}');
      throw Exception('Failed to send message to ${message.receiverName}. Please try again.');
    }
    catch(e){
      log('${AppStrings.chatRepoLog}Error sending message to ${message.receiverName}: $e');
      throw Exception('Failed to send message to ${message.receiverName}. Please try again.');
    }
  }

  Future<String> uploadFile({required String filename, required File file}) async{
    try{
      final url = await _supabaseService.uploadFile(file, 'chats/$filename');
      return url;
    }
    on StorageException catch(e){
      log('${AppStrings.chatRepoLog}Supabase Error uploading file: ${e.statusCode} - ${e.error}  - ${e.message}');
      throw Exception('Failed to upload file. Please try again.');
    }
    catch(e){
      log('${AppStrings.chatRepoLog}Error uploading file: $e');
      throw Exception('Failed to upload file. Please try again');
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

  Map<String,Download> getDownloadStatesFromLocalStorage(){
    try{
      final savedDownloadStates = _hiveService.getDownloadStates();
      final downloadStates = savedDownloadStates.map((key, value) {
        final downloadEnum = Download.values.firstWhere(
              (e) => e.name == value,
          orElse: () => Download.download,
        );
        return MapEntry(key, downloadEnum);
      });
      return downloadStates;
    }catch(e){
      log('${AppStrings.chatRepoLog}failed to get download states: $e');
      throw Exception('${AppStrings.chatRepoLog}failed to get download states: $e');
    }
  }

  Future<void> updateDownloadStatesToLocalStorage({required String urlKey, required String downloadState})async{
    try{
      await _hiveService.updateDownloadStates(urlKey: urlKey, downloadState: downloadState);
    }catch(e){
      log('${AppStrings.chatRepoLog}failed to get download states: $e');
      throw Exception('${AppStrings.chatRepoLog}failed to get download states: $e');
    }
  }

}