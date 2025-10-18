
class InChatGeminiMessage{
  final String message;
  final bool isUser;
  final String? filepath;
  InChatGeminiMessage({required this.message, required this.isUser, this.filepath});
}