// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:jonnverse/ui/common/exception_handler.dart';
// import 'package:jonnverse/ui/common/strings.dart';
//
// class OtherAIService {
//   Future<String> sendChatMessage({
//     required List<Map<String, String>> history,
//     required String model,
//     required String? apiKey,
//     required String baseUrl,
//   }) async {
//     if (apiKey == null) {
//       log('Error: API_KEY not found in .env file.');
//       return 'API Key not configured.';
//     }
//     final url = Uri.parse(baseUrl);
//     try {
//       final response = await http.post(
//             url,
//             headers: {
//               AppStrings.contentType: AppStrings.applicationJson,
//               AppStrings.authorization: "Bearer $apiKey",
//             },
//             body: jsonEncode({"model": model, "messages": history}),
//           )
//           .timeout(
//             const Duration(seconds: 30),
//             onTimeout: () {
//               throw Exception('Connection timeout, poor internet');
//             },
//           );
//
//       log('${response.statusCode}');
//       ExceptionHandler.checkStatusCode(response.statusCode);
//       if (response.statusCode == 200) {
//         log('Successful: ${response.body}');
//         final data = jsonDecode(response.body);
//         return data['choices'][0]['message']['content'].toString().trim();
//       } else {
//         log('failed to get result from the endpoint');
//         throw Exception('Chat failed: ${response.body}');
//       }
//     } on http.ClientException catch (e) {
//       log('Error: ${e.message}');
//       return e.message;
//     } catch (e) {
//       log(e.toString());
//       return 'request failed: $e';
//     }
//   }
//
//
//   Future<String> sendMessageWithFile({
//     required List<Map<String, String>> history,
//     required File file,
//     required String model,
//     required String baseUrl,
//     required String? apiKey,
//   }) async {
//     if (apiKey == null) {
//       log('Error: API_KEY not found in .env file.');
//       return 'API Key not configured.';
//     }
//     final url = Uri.parse(baseUrl);
//     try {
//       final request =
//           http.MultipartRequest("POST", url)
//             ..headers["Authorization"] = "Bearer $apiKey"
//             ..fields["model"] = model
//             ..fields["messages"] = jsonEncode(history)
//             ..files.add(await http.MultipartFile.fromPath("file", file.path));
//
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse).timeout(
//         const Duration(seconds: 90),
//         onTimeout: () {
//           throw Exception('Connection timeout, poor internet');
//         },
//       );
//       log('${response.statusCode}');
//       ExceptionHandler.checkStatusCode(response.statusCode);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['choices'][0]['message']['content'].toString().trim();
//       } else {
//         throw Exception('File processing failed: ${response.body}');
//       }
//     } on http.ClientException catch (e) {
//       log('Error: ${e.message}');
//       return e.message;
//     } catch (e) {
//       log(e.toString());
//       return 'request failed: $e';
//     }
//   }
//
//   Future<List<Map<String, String>>> convertMessagesToContentHistory(
//     List<Message> messages, String forbiddenMessage,
//   ) async {
//     log('Fetching history started');
//     List<Map<String, String>> history = [];
//     for (var message in messages) {
//       if (message.text != forbiddenMessage) {
//         if (message.text != null ||
//             message.filePath != null ||
//             message.image != null) {
//           if (message.isUser) {
//             history.add({"role": "user", "content": message.text!});
//           } else {
//             history.add({"role": "assistant", "content": message.text!});
//           }
//         } else {
//           log(
//             'Skipped this $message because it has no text, image or file: ${message.toString()}',
//           );
//         }
//       } else {
//         log('Skipped the pre-added message: ${message.text}');
//       }
//     }
//     log(
//       'Fetching history completed: ${history.length} of ${messages.length} messages',
//     );
//     return history;
//   }
//
// }
