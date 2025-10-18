import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/in_chat_gemini_message.dart';
import 'package:jonnverse/core/repos/chat_repo.dart';
import 'package:jonnverse/core/repos/connectivity_repo.dart';
import 'package:jonnverse/ui/common/strings.dart';

class InChatGeminiState{
  final bool isMessagePressed;
  final String? messageContent;
  final String? fileContent;
  final String? fileNameContent;
  final String? imageFileContent;
  final bool contentLoading;
  final bool conversationStarted;
  final List<InChatGeminiMessage> messages;
  InChatGeminiState({this.messages = const[], this.contentLoading = false, this.conversationStarted = false, this.fileContent,this.fileNameContent, this.imageFileContent, this.messageContent, this.isMessagePressed = false,});
  InChatGeminiState copyWith({bool? contentLoading, String? prompt, bool? conversationStarted, List<InChatGeminiMessage>? messages, String? imageFileContent, String? fileContent, String? fileNameContent, String? messageContent, bool? isMessagePressed,}){
    return InChatGeminiState(
      isMessagePressed: isMessagePressed ?? this.isMessagePressed,
      messageContent: messageContent ?? this.messageContent,
      fileContent: fileContent ?? this.fileContent,
      imageFileContent: imageFileContent ?? this.imageFileContent,
      contentLoading: contentLoading ?? this.contentLoading,
      fileNameContent: fileNameContent ?? this.fileNameContent,
      messages: messages ?? this.messages,
      conversationStarted: conversationStarted ?? this.conversationStarted,
    );
  }
}

class InChatGeminiNotifier extends Notifier<InChatGeminiState>{
  final ConnectivityRepo _connectivityRepo = locator<ConnectivityRepo>();
  final ChatRepo _chatRepo = locator<ChatRepo>();
  @override
  InChatGeminiState build() => InChatGeminiState();

  void updateMessagePressed({required bool value,required String? message,required String? file,required String? imageFile, bool? loading,required String? fileName, bool? started, List<InChatGeminiMessage>? messages,}){
    state = state.copyWith(isMessagePressed: value,
        messageContent: message,
        fileContent: file,
        imageFileContent: imageFile,
        contentLoading: loading,
        fileNameContent: fileName,
      messages: messages,
      conversationStarted: started,
    );
  }

  void closeMessagePressed(){
    state = InChatGeminiState(
      isMessagePressed: false,
      messageContent: null,
      fileContent: null,
      imageFileContent: null,
      contentLoading: false,
      fileNameContent: null,
      messages: [],
      conversationStarted: false,
    );
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

  Future<String?> promptGemini(InChatGeminiMessage message, ScrollController scrollController)async{
    if(await _connectivityRepo.hasInternet() == false) return AppStrings.noInternet;
    final tempMessage = InChatGeminiMessage(message: AppStrings.geminiThinking, isUser: false);
    try{
      state = state.copyWith(contentLoading: true);
      final newList = List<InChatGeminiMessage>.from(state.messages);
      newList.add(message);
      newList.add(tempMessage);
      state = state.copyWith(messages: newList);
      final response = await _chatRepo.inChatGeminiSendMessage(messages: state.messages, prompt: message.message, file: message.filepath != null ? File(message.filepath!) : null);
      if(response == null) return 'Failed to get response';
      final finalList = List<InChatGeminiMessage>.from(state.messages);
      finalList.removeLast();
      finalList.add(InChatGeminiMessage(message: response, isUser: false));
      state = state.copyWith(messages: finalList, conversationStarted: true);
      scrollToBottom(scrollController);
      return null;
    }catch(e){
      final finalList = List<InChatGeminiMessage>.from(state.messages);
      finalList.removeLast();
      state = state.copyWith(messages: finalList);
      log('Error getting response Gemini: $e');
      return e.toString().replaceFirst('Exception: ', '');
    }finally{
      state = state.copyWith(contentLoading: false);
    }
  }

}

final inChatGeminiNotifierProvider = NotifierProvider<InChatGeminiNotifier, InChatGeminiState>(InChatGeminiNotifier.new);