import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:mime/mime.dart';

class GeminiAIService {
  final String? _geminiApiKey = dotenv.env['GOOGLE_API_KEY'];

  GenerativeModel _getGeminiModel({required String modelName}) {
    if (_geminiApiKey == null) {
      log('Error: GOOGLE_API_KEY not found in .env file.');
      throw Exception('API Key not configured for Gemini.');
    }
    return GenerativeModel(model: modelName, apiKey: _geminiApiKey);
  }

  Future<String?> geminiGenerateWithText({
    required String prompt,
    List<Content>? conversationHistory,}) async {
    if (_geminiApiKey == null) {
      log('Error: GOOGLE_API_KEY not found in .env file.');
      return 'API Key not configured.';
    }

    final model = _getGeminiModel(modelName: AppStrings.geminiFlash);
    final chat = model.startChat(history: conversationHistory);
    final content = Content.text(prompt);

    final response = await chat.sendMessage(content);
    log('Gemini API Response: ${response.text}');
    return response.text;
  }


  Future<String?> geminiGenerateWithTextAndFile({
    required String prompt,
    required Uint8List fileBytes, required String fileMimeType,
    List<Content>? conversationHistory,
  }) async {
    if (_geminiApiKey == null) {
      log('Error: GOOGLE_API_KEY not found in .env file.');
      return 'API Key not configured.';
    }

    final model = _getGeminiModel(modelName: AppStrings.geminiFlash);
    final chat = model.startChat(history: conversationHistory);

    List<Part> parts = [];
    parts.add(TextPart(prompt));
    parts.add(DataPart(fileMimeType, fileBytes));
    final content = Content.multi(parts);

    final response = await chat.sendMessage(content);
    log('Gemini API Response: ${response.text}');
    return response.text;
  }

  Future<DataPart?> convertFileToDataPart(File? file) async {
    if (file == null) return null;
    Uint8List fileBytes;
    String lookupPathOrName;
   if (file.path.isNotEmpty) {
      fileBytes = await File(file.path).readAsBytes();
      lookupPathOrName = file.path;
    } else {
      log('Error: Could not get bytes for file ${file.path}');
      return null;
    }
    final String? fileMimeType = lookupMimeType(lookupPathOrName, headerBytes: fileBytes.sublist(0, defaultMagicNumbersMaxLength));
    final String finalMimeType = fileMimeType ?? '';
    log('File mime type: $finalMimeType');
    return DataPart(finalMimeType, fileBytes);
  }


  Future<List<Content>> convertMessagesToContentHistory(List<JMessage> messages, String userMail) async {
    log('Fetching Gemini chat history started');
    List<Content> history = [];
    for (final message in messages) {
      List<Part> parts = [];
        if (message.message != null && message.message!.trim().isNotEmpty) {
          parts.add(TextPart(message.message!));
        }

        if (message.filePath != null) {
          try {
            final file = File(message.filePath!);
            if (await file.exists()) {
              final Uint8List fileBytes = await file.readAsBytes();
              final String? mimeType = lookupMimeType(
                  message.filePath!,
                  headerBytes: fileBytes.sublist(0, defaultMagicNumbersMaxLength)
              );
              parts.add(DataPart(mimeType ?? 'application/octet-stream', fileBytes));
            } else {
              log('Skipping file in history: File not found at ${message.filePath}');
            }
          } catch (e) {
            log('Error processing file from history for ${message.filePath}: $e');
          }
        }

        if (parts.isNotEmpty) {
          if (message.senderMail == userMail) {
            history.add(Content('user', parts));
          } else {
            history.add(Content('model', parts));
          }
        } else {
          log('Skipping message in history conversion (no valid parts): ${message.message?.substring(0, 20) ?? "Media message"}');
        }

    }
    log('Fetching history completed; ${history.length} messages converted out of ${messages.length}.');
    return history;
  }

}






// Future<String?> geminiGenerateWithTextAndImage(
//     {required String prompt,
//       required Uint8List imageBytes,
//       required String imageMimeType,
//       List<Content>? conversationHistory,
//       required String modelName}) async {
//   if (_geminiApiKey == null) {
//     log('Error: GOOGLE_API_KEY not found in .env file.');
//     return 'API Key not configured.';
//   }
//
//   final model = _getGeminiModel(modelName: modelName);
//   final chat = model.startChat(history: conversationHistory);
//
//   List<Part> parts = [];
//   parts.add(TextPart(prompt));
//   parts.add(DataPart(imageMimeType, imageBytes));
//   final content = Content.multi(parts);
//
//   final response = await chat.sendMessage(content);
//   log('Gemini API Response: ${response.text}');
//   return response.text;
// }

//  Future<DataPart?> convertImageToDataPart(File? imageFile) async {
//     if (imageFile == null) return null;
//     final Uint8List imageBytes = await imageFile.readAsBytes();
//     final String? imageMimeType = lookupMimeType(imageFile.path, headerBytes: imageBytes.sublist(0, defaultMagicNumbersMaxLength));
//     final String finalMimeType = imageMimeType ?? 'image/jpeg';
//     // final String finalMimeType = fileMimeType ?? 'application/octet-stream';
//     return DataPart(finalMimeType, imageBytes);
//   }