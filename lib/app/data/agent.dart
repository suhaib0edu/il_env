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
    try {
      final savedModel = await storage.read(key: 'selectedModel');
      final selectedModelType =
          savedModel == ModelType.gpt.name ? ModelType.gpt : ModelType.gemini;

      final apiKey = await storage.read(key: selectedModelType.name) ?? '';
      if (apiKey.isEmpty) {
        throw Exception('API key is empty');
      }

      final response = await ChatAgent(apiKey, selectedModelType)
          .engageInChat(systemInstruction, userMessage);

      return AgentUtils().cleanJson(response);
    } catch (e) {
      debugPrint('Agent error initiateChat: $e');
      return '';
    }
  }
}

class AgentUtils {
  String lessonKeysPrompt() => '''

قم بفهم النص بعمق و تحليل الدرس أو الموضوع المحدد لتحديد الأهداف الرئيسية و المفاهيم الأساسية والنقاط المهمة التي يجب التركيز عليها وتخزينها في متغيرات مناسبة داخل تنسيق بصيغة JSON.

# تفاصيل إضافية

قم بتقييم الدرس بعمق، وركز على استخراج عناصر المعرفة التالية:
- الأهداف الرئيسية للدرس: ما الذي يجب على الطلاب بيانه أو تعلمه بنهاية الدرس.
- المفاهيم الأساسية: الأفكار أو النظريات المهمة التي يحتاج الطلاب لفهمها.
- النقاط المهمة التي يجب التركيز عليها: الأفكار الأساسية والنقاط البارزة خلال الدرس.


# ملحوظات

- يجب التركيز على الدقة والوضوح في تحديد النقاط والمفاهيم.
- تغطية شاملة لكل عنصر لضمان أن الملخص يعكس معالم الدرس بشكل كاف.
- أن تكون الأهداف والمفاهيم والنقاط محددة بوضوح ومختصرة.

يجب أن يكون المخرج JSON فقط  كما يلي:

{
    "summary": {
        "lesson_objectives": [
            "هدف 1",
            "هدف 2",
            "هدف 3"
        ],
        "key_concepts": [
            "مفهوم 1",
            "مفهوم 2",
            "مفهوم 3"
        ],
        "important_points": [
            "نقطة مهمة 1",
            "نقطة مهمة 2",
            "نقطة مهمة 3"
        ]
    }
}


''';

  String divider() => '''

قم بتقسيم النص المقدم إلى أجزاء أو فقرات مفهومة وواضحة، واحفظ كل جزء في قائمة. يجب أن يتضمن الإخراج جميع الأجزاء دون اختصار أو تلخيص. 
اذا كان النص لا يحتوى على عناوين كثيرة انشئ عناوين ببساطة تناسب كل فقرة.
الغرض من عملية التقسيم هي مساعدة الطلاب على فهم الدرس بشكل افضل، لذلك احرص على تحقيق هذا الهدف


# ملاحظات

- تأكد من أن كل جزء يحتوي على عنوان ومحتوى.
- يجب أن تكون الأجزاء مفهومة وواضحة.
- لا تختصر أو تلخيص النص.
- الاخراج يجب ان يكون بتنسيق JSON فقط و يتكون من content_parts تحتوي على قامة من الاجزاء ستعبر t عن العنوان و c عن المحتوى
- لا يسمح لك باختصار المحتوي عليك فقط تقسيمه الي اجزاء متعددة

يجب أن يكون المخرج JSON فقط كما يلي:

{
    "content_parts": [
        {"t" : "عنوان الجزء 1",
        "c":"محتوى الجزء 1"
        },
        {"t" : "عنوان الجزء 2",
        "c":"محتوى الجزء 2"
        },
        {"t" : "عنوان الجزء 3",
        "c":"محتوى الجزء 3"
        }
    ]
}
''';

  String cleanJson(String input) {
    final regex = RegExp(r'```json\s*(.*?)\s*```', dotAll: true);
    final match = regex.firstMatch(input);

    if (match != null && match.groupCount > 0) {
      return match.group(1)!.trim(); // استخدم المجموعة الأولى
    } else {
      return input; // إذا لم يتم العثور على JSON، أعد النص كما هو
    }
  }

  String formatObjectivesAsMarkdown(dynamic objectives) {
    StringBuffer markdown = StringBuffer();

    for (var objective in objectives) {
      markdown.writeln('- $objective');
    }

    return markdown.toString();
  }
}
