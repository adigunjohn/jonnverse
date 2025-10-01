// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mime/mime.dart';
//
// class GeminiAIService {
//   final String? _geminiApiKey = dotenv.env['GOOGLE_API_KEY'];
//
//   GenerativeModel _getGeminiModel({required String modelName}) {
//     if (_geminiApiKey == null) {
//       log('Error: GOOGLE_API_KEY not found in .env file.');
//       throw Exception('API Key not configured for Gemini.');
//     }
//     return GenerativeModel(model: modelName, apiKey: _geminiApiKey);
//   }
//
//   Future<String?> geminiGenerateWithText({
//     required String prompt,
//     List<Content>? conversationHistory,
//     required String modelName,}) async {
//     if (_geminiApiKey == null) {
//       log('Error: GOOGLE_API_KEY not found in .env file.');
//       return 'API Key not configured.';
//     }
//
//     final model = _getGeminiModel(modelName: modelName);
//     final chat = model.startChat(history: conversationHistory);
//     final content = Content.text(prompt);
//
//     try {
//       final response = await chat.sendMessage(content);
//       log('Gemini API Response: ${response.text}');
//       return response.text;
//     } on GenerativeAIException catch (e) {
//       log('GenerativeAIException : $e');
//       return 'Error from Gemini: ${e.message}';
//     } catch (e) {
//       log('Unknown error in Gemini API: $e');
//       return 'An unknown error occurred.';
//     }
//   }
//
//   Future<String?> geminiGenerateWithTextAndImage(
//       {required String prompt,
//         required Uint8List imageBytes,
//         required String imageMimeType,
//         List<Content>? conversationHistory,
//         required String modelName}) async {
//     if (_geminiApiKey == null) {
//       log('Error: GOOGLE_API_KEY not found in .env file.');
//       return 'API Key not configured.';
//     }
//
//     final model = _getGeminiModel(modelName: modelName);
//     final chat = model.startChat(history: conversationHistory);
//
//     List<Part> parts = [];
//     parts.add(TextPart(prompt));
//     parts.add(DataPart(imageMimeType, imageBytes));
//     final content = Content.multi(parts);
//
//     try {
//       final response = await chat.sendMessage(content);
//       log('Gemini API Response: ${response.text}');
//       return response.text;
//     } on GenerativeAIException catch (e) {
//       log('GenerativeAIException: $e');
//       return 'Error from Gemini: ${e.message}';
//     } catch (e) {
//       log('Unknown error in Gemini API: $e');
//       return 'An unknown error occurred.';
//     }
//   }
//
//
//   Future<String?> geminiGenerateWithTextAndFile({
//     required String prompt,
//     required Uint8List fileBytes, required String fileMimeType,
//     List<Content>? conversationHistory,
//     required String modelName,
//   }) async {
//     if (_geminiApiKey == null) {
//       log('Error: GOOGLE_API_KEY not found in .env file.');
//       return 'API Key not configured.';
//     }
//
//     final model = _getGeminiModel(modelName: modelName);
//     final chat = model.startChat(history: conversationHistory);
//
//     List<Part> parts = [];
//     parts.add(TextPart(prompt));
//     parts.add(DataPart(fileMimeType, fileBytes));
//     final content = Content.multi(parts);
//
//     try {
//       final response = await chat.sendMessage(content);
//       log('Gemini API Response: ${response.text}');
//       return response.text;
//     } on GenerativeAIException catch (e) {
//       log('GenerativeAIException: $e');
//       return 'Error from Gemini: ${e.message}';
//     } catch (e) {
//       log('Unknown error in Gemini API: $e');
//       return 'An unknown error occurred.';
//     }
//   }
//
//
//   Future<DataPart?> convertImageToDataPart(XFile? imageFile) async {
//     if (imageFile == null) {return null;}
//     final Uint8List imageBytes = await imageFile.readAsBytes();
//     final String? imageMimeType = lookupMimeType(imageFile.path, headerBytes: imageBytes.sublist(0, defaultMagicNumbersMaxLength));
//     final String finalMimeType = imageMimeType ?? 'image/jpeg';
//     return DataPart(finalMimeType, imageBytes);
//   }
//
//   Future<DataPart?> convertFileToDataPart(PlatformFile? file) async {
//     if (file == null) {return null;}
//     Uint8List fileBytes;
//     String lookupPathOrName;
//     if (file.bytes != null) {
//       fileBytes = file.bytes!;
//       lookupPathOrName = file.name;
//     } else if (file.path != null) {
//       fileBytes = await File(file.path!).readAsBytes();
//       lookupPathOrName = file.path!;
//     } else {
//       log('Error: Could not get bytes for file ${file.name}');
//       return null;
//     }
//     final String? fileMimeType = lookupMimeType(lookupPathOrName, headerBytes: fileBytes.sublist(0, defaultMagicNumbersMaxLength));
//     final String finalMimeType = fileMimeType ?? 'application/octet-stream';
//     log('File mime type: $finalMimeType');
//     return DataPart(finalMimeType, fileBytes);
//   }
//
//
//   Future<List<Content>> convertMessagesToContentHistory(List<Message> messages) async {
//     log('Fetching history started');
//     List<Content> history = [];
//     for (final message in messages) {
//       List<Part> parts = [];
//       if(message.text != 'Hi! I\'m Gemini.\nHow can I help you?') {
//         if (message.text != null && message.text!.trim().isNotEmpty) {
//           parts.add(TextPart(message.text!));
//         }
//
//         if (message.image != null) {
//           try {
//             final imageFile = File(message.image!);
//             if (await imageFile.exists()) {
//               final Uint8List imageBytes = await imageFile.readAsBytes();
//               final String? mimeType = lookupMimeType(
//                   message.image!,
//                   headerBytes: imageBytes.sublist(0, defaultMagicNumbersMaxLength)
//               );
//               if (mimeType != null && mimeType.startsWith('image/')) {
//                 parts.add(DataPart(mimeType, imageBytes));
//               } else {
//                 log('Skipping image in history: Could not determine valid image MIME type for ${message.image}');
//               }
//             } else {
//               log('Skipping image in history: File not found at ${message.image}');
//             }
//           } catch (e) {
//             log('Error processing image from history for ${message.image}: $e');
//           }
//         }
//
//         if (message.filePath != null) {
//           try {
//             final file = File(message.filePath!);
//             if (await file.exists()) {
//               final Uint8List fileBytes = await file.readAsBytes();
//               final String? mimeType = lookupMimeType(
//                   message.filePath!,
//                   headerBytes: fileBytes.sublist(0, defaultMagicNumbersMaxLength)
//               );
//               parts.add(DataPart(mimeType ?? 'application/octet-stream', fileBytes));
//             } else {
//               log('Skipping file in history: File not found at ${message.filePath}');
//             }
//           } catch (e) {
//             log('Error processing file from history for ${message.filePath}: $e');
//           }
//         }
//
//         if (parts.isNotEmpty) {
//           if (message.isUser) {
//             history.add(Content('user', parts));
//           } else {
//             history.add(Content('model', parts));
//           }
//         } else {
//           log('Skipping message in history conversion (no valid parts): ${message.text?.substring(0, 20) ?? "Media message"}');
//         }
//       }
//       else{
//         log('skipped the first pre-added message: ${message.text}');
//       }
//
//     }
//     log('Fetching history completed; ${history.length} messages converted out of ${messages.length}.');
//     return history;
//   }
//
// }
//
