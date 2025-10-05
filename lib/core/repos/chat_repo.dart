import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/ui/common/strings.dart';

class ChatRepo{
  final FirebaseService _firebaseService = locator<FirebaseService>();

  Future<void> createChat({required String otherUserName, required String chatId,required JMessage message}) async{
    try{
      await _firebaseService.createChat(chatId, message);
      log('${AppStrings.chatRepoLog}Chat with $otherUserName created successfully');
    }
    on FirebaseException catch(e){
      log('${AppStrings.chatRepoLog}Firebase Error creating chat: ${e.code} - ${e.message}');
      throw Exception('Failed to create chat with $otherUserName. Please try again.');
    }
    catch(e){
      log('${AppStrings.chatRepoLog}Error creating chat: $e');
      throw Exception('Failed to create chat with $otherUserName. Please try again.');
    }
  }

}