import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:il_env/index.dart';

enum ModelType { gemini, gpt }

abstract class ContentGenerator {
  final String apiKey;
  final String endpoint;
  final ModelType modelType;
  late final Map<String, String> headers;

  ContentGenerator(this.apiKey, this.modelType)
      : endpoint = modelType == ModelType.gemini
            ? 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey'
            : 'https://api.openai.com/v1/chat/completions' {
    headers = {
      'Content-Type': 'application/json',
      if (modelType == ModelType.gpt) 'Authorization': 'Bearer $apiKey',
    };
  }

  Future<String> _sendRequest(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw HttpException('Error: ${response.statusCode} - ${response.body}');
    }

    return _parseResponse(utf8.decode(response.bodyBytes));
  }

  String _parseResponse(String responseBody) {
    final data = jsonDecode(responseBody);
    return modelType == ModelType.gpt
        ? data['choices']?.first['message']['content'] ??
            'Error extracting content'
        : data['candidates']?.first['content']['parts']?.first['text'] ??
            'Error extracting content';
  }

  Future<String> generateContent(
      String systemInstruction, String content) async {
    final payload = _buildPayload(systemInstruction, content);
    return await _sendRequest(payload);
  }

  Map<String, dynamic> _buildPayload(String systemInstruction, String content) {


    return modelType == ModelType.gemini
        ? {
            "system_instruction": {
              "parts": {"text": systemInstruction}
            },
            "contents": {
              "parts": {"text": content}
            },
          }
        : {
            'model': 'gpt-4o-mini',
            'messages': [
              {'role': 'system', 'content': systemInstruction},
              {'role': 'user', 'content': content},
            ],
          };
  }
}

class ChatAgent extends ContentGenerator {
  ChatAgent(super.apiKey, super.modelType);

  Future<String> engageInChat(
      String systemInstruction, String userMessage) async {
    try {
      debugPrint('thinking...');
      final response = await generateContent(systemInstruction, userMessage);
      debugPrint(response);
      return response;
    } catch (e) {
      if (e is HttpException) {
        debugPrint('Chat error engageInChat(h): ${e.message}');
        errorSnackbar(TranslationKey.keyApiKeyError);
        Get.toNamed(Routes.SETTINGS);
        return '';
      } else {
        debugPrint('Chat error engageInChat(e): $e');
        errorSnackbar(TranslationKey.keyCheckConnection);
        return '';
      }
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
}

class Agent {
  Future<String> initiateChat(
      String systemInstruction, String userMessage) async {
    final savedModel = await storage.read(key: 'selectedModel');
    final selectedModelType =
        savedModel == ModelType.gpt.name ? ModelType.gpt : ModelType.gemini;

    final apiKey = await storage.read(key: selectedModelType.name) ?? '';
    return await ChatAgent(apiKey, selectedModelType)
        .engageInChat(systemInstruction, userMessage);
  }
}
