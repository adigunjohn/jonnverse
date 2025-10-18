import 'package:flutter_riverpod/flutter_riverpod.dart';

class InChatGeminiState{
  final bool isMessagePressed;
  final String? messageContent;
  final String? fileContent;
  final String? fileNameContent;
  final String? imageFileContent;
  final bool contentLoading;
  InChatGeminiState({this.contentLoading = false, this.fileContent,this.fileNameContent, this.imageFileContent, this.messageContent, this.isMessagePressed = false,});
  InChatGeminiState copyWith({bool? contentLoading, String? imageFileContent, String? fileContent, String? fileNameContent, String? messageContent, bool? isMessagePressed,}){
    return InChatGeminiState(
      isMessagePressed: isMessagePressed ?? this.isMessagePressed,
      messageContent: messageContent ?? this.messageContent,
      fileContent: fileContent ?? this.fileContent,
      imageFileContent: imageFileContent ?? this.imageFileContent,
      contentLoading: contentLoading ?? this.contentLoading,
      fileNameContent: fileNameContent ?? this.fileNameContent,
    );
  }
}

class InChatGeminiNotifier extends Notifier<InChatGeminiState>{
  @override
  InChatGeminiState build() => InChatGeminiState();

  void updateMessagePressed({required bool value,String? message,String? file, String? imageFile, bool? loading, String? fileName}){
    state = state.copyWith(isMessagePressed: value, messageContent: message, fileContent: file, imageFileContent: imageFile, contentLoading: loading, fileNameContent: fileName);
  }

}

final inChatGeminiNotifierProvider = NotifierProvider<InChatGeminiNotifier, InChatGeminiState>(InChatGeminiNotifier.new);