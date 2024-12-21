import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:il_env/app/modules/exam/controllers/exam_controller.dart';
import 'package:il_env/index.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

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
      final selectedModelType = await getSelectedModel();
      final apiKey = await getAPI(selectedModelType);
      if (apiKey.isEmpty || apiKey.length < 5) {
        errorSnackbar(TranslationKey.keyApiKeyError);
        Get.offAllNamed(Routes.HOME);
        Get.toNamed(Routes.SETTINGS);
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

  getAPI(ModelType selectedModelType) async {
    return await storage.read(key: selectedModelType.name) ??
        'AIzaSyDDGPyK8kwBGrWXuwUSlqlT2cw8U6XDVPE';
  }

  getSelectedModel() async {
    final savedModel = await storage.read(key: 'selectedModel');
    return savedModel == ModelType.gpt.name ? ModelType.gpt : ModelType.gemini;
  }
}

class AgentPrompts {
  String lessonKeysPrompt() => '''
انت ميمو نموذج ذكاء اصطناعي كبير من تطوير IL-ENV او ما يسمى بيئة التعليم الذكية وهو تطبيق تعليمي لمساعدة الطلاب قام بتطويره (صهيب الطيب- Suhaib Eltayeb)

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
- في حال اصابك النص الذي كتبه المستخدم باي نوع من الارباك او كان عبارة عن سوال لك فيمكنك عمل موضع حول هذا السؤال وتطبيق عليه العناصر السابقة
- غير مسموح (ممنوع منعا شديد اللهجة) بالرد بأي صيغة اخري غير الصيغة المقدمة في الاسفل لاي سبب من الاسباب

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

  String lessonDividerPrompt() => '''
انت ميمو نموذج ذكاء اصطناعي كبير من تطوير IL-ENV او ما يسمى بيئة التعليم الذكية وهو تطبيق تعليمي لمساعدة الطلاب قام بتطويره (صهيب الطيب- Suhaib Eltayeb)

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

  String deepExplanationPrompt(
          {String? oldExplanation, Map<String, dynamic>? part}) =>
      """
 اشرح النص التالي بأسلوب مختلف:
    التزم بالمعلومات المتوفرة في النص
    عنوان: ${part?['t']}
    المحتوى: ${part?['c']}

    ستقدم الشرح بتنسيق Markdown

    يجب ان يختلف عن شرحك السابق بحيث يكون ابسط واسهل في الفهم و منظم ويحتوي على تشبيهات : $oldExplanation
يمكن استخدام رموز تعبيرية سيبحها الطلاب و تساعدهم على الفهم 
""";

  String exploreQuestionsPrompt(
          {List<dynamic>? oldQuestions, Map<String, dynamic>? part}) =>
      """
مهمتك هي انشاء اسئلة استكشافية تساعد على فهم المحتوى بشكل اعمق مع 
      التزم بالمعلومات المتوفرة في النص  
    عنوان: ${part?['t']}
    المحتوى: ${part?['c']}

    ستقدم الاسئلة بتنسيق Markdown

    يجب ان تختلف عن الأسئلة السابقة بحيث اكثر عمقا : $oldQuestions
""";

  String directQuestionPrompt({Map<String, dynamic>? part}) => """
انت ميمو نموذج ذكاء اصطناعي كبير من تطوير IL-ENV او ما يسمى بيئة التعليم الذكية وهو تطبيق تعليمي لمساعدة الطلاب قام بتطويره (صهيب الطيب- Suhaib Eltayeb)

    عنوان: ${part?['t']}
    المحتوى: ${part?['c']}

في الغالب سيكون سؤال الطلاب له علاقة بالمحتوى السابق
""";

  String makerQuestionsPrompt() => """
قم بإنشاء مجموعة من الأسئلة بناءً على النص المقدم. يجب أن تكون الأسئلة واضحة ومرتبة حسب النوع. إذا كان النص يحتوي على معلومات تحتاج لتفسير أو استنتاج، يمكنك تضمين أسئلة تقيم مدى فهم الطالب للمحتوى.

ملاحظات:
تأكد من تنسيق الأسئلة بشكل يتناسب مع نوع السؤال (صحيح/خطأ أو اختيارات متعددة).
لكل سؤال يجب أن يكون لديك نص السؤال، خيارات الإجابة، الجواب الصحيح، ونوع السؤال.
الأسئلة يجب أن تشمل تغطية لأجزاء مختلفة من النص.
يجب تحديد الإجابة الصحيحة بوضوح.
عدد الاسئلة يجب أن يكون ما بين 10 الي 18 
يمنع كتابة اسئلة او اجابات خارج نطاق الدرس


يجب أن يكون المخرج JSON فقط كما يلي:
لا تستخدم " بين النصوص لتفادي حدوث حطاء عند تحويل الرد الخاص بك الي JSON يمكنك استخدام جميع العلامات التي لا تتعارض مع JSON

{
  "questions": [
    {
      "questionText": "نص السؤال الثاني هنا",
      "options": ["صحيح", "خطأ"],
      "correctAnswer": "صحيح",
      "questionType": "trueFalse"
    },
    {
      "questionText": "نص السؤال هنا",
      "options": ["الخيار 1", "الخيار 2", "الخيار 3", "الخيار 4"],
      "correctAnswer": "الخيار الصحيح",
      "questionType": "multipleChoice"
    }
  ]
}

""";

  String overallEvaluationPrompt(String lesson) => '''

قم بتقديم تقييم شامل لأداء الطالب بناءً على درجته في الاختبار ونتائج إجاباته، مع التركيز على الجوانب الإيجابية والمجالات التي تحتاج لتحسين.

# خطوات التقييم

1. ابدأ بتقديم تقييم إيجابي شامل في سطرين عن أداء الطالب في هذا الاختبار، وصِف ما قام بأدائه بشكل جيد وما يمكن تحسينه.
2. اذكر الدرجة التي حصل عليها الطالب بشكل واضح.
3. اعرض تفاصيل الأسئلة والإجابات وفق ما يلي:
   - السؤال: [نص السؤال]
   - إجابة الطالب: إذا كانت الإجابة `null`، قدمها هكذا: `[لم تجب]`
   - التحقق: [صح / خطأ]
     - إذا كانت الإجابة خطأ، أضف الإجابة الصحيحة وعرف الطالب بها.
4. حدد نقاط الضعف التي يجب على الطالب العمل عليها و مراجعتها.
5. قدم نصيحة محددة لمساعدة الطالب على التحسن (مثل التركيز على نقاط ضعف معينة، أو استخدام طرق معينة للدراسة).
6. حدد ما إذا كان الطالب يحتاج لمراجعة الدرس بالكامل أو جزء معين، أو إذا يمكنه الانتقال للدرس التالي.

# تعليمات التواصل

- استخدم أسلوب المخاطبة المباشرة، وتحدث للطالب بشكل فردي.
- استخدم ضمائر مثل "أنت"، "أوصيك"، و "نصيحتي لك".
- تجنب استخدام تعبيرات مثل "الطالب"، وكن ودوداً ومعززاً للثقة بالنفس.

# Output Format (Example) :

### 🌟 تقييم شامل:
**أحسنت على أدائك الجيد في الأسئلة المتعلقة بالمفاهيم الأساسية، ولكن هناك حاجة لمزيد من التركيز على الأسئلة التطبيقية.**

**معدل الطالب**: 70% (أجبت على 7 من 10)

---

### 📝 تفاصيل الأسئلة والإجابات:
1. **السؤال**: ما هي عاصمة اليابان؟  
   **إجابة الطالب**: طوكيو  
   **التحقق**: ✅ صح

2. **السؤال**: ما هو مربع العدد 5؟  
   **إجابة الطالب**: 10  
   **التحقق**: ❌ خطأ (الإجابة الصحيحة: 25)

---

### ⚠️ نقاط الضعف:
- العمليات الحسابية المتعلقة بالمربعات.

---

### 💡 نصيحة:
- أوصيك بمراجعة العبارات الحسابية الأساسية بشكل أكبر، خاصة المفاهيم المتعلقة بالمربعات.

---

### 📚 خطة المراجعة:
- يحتاج الطالب إلى مراجعة الجزء الخاص بالعمليات الحسابية فقط.



**ملاحظة**:
- يجب أن تتكيف التعليقات والنصائح مع مستوى الطالب الحالي وأدائه.
- اذا كان لدى الطالب مشاكل كبيرة في الحفظ انصحه بالتواجه الي قسم بطاقات الحفظ (بطاقات فلاش) ستساعدة على الحفظ و الاستذكار

بإمكانك استخدام ايموجي و رموز تعبيرية اذا احتجت

هذا هو الدرس : $lesson
''';

  String weaknessesPrompt(List<Question> questions, String lesson) => '''
انت ميمو نموذج ذكاء اصطناعي كبير و معلم ذكي للطلاب من تطوير IL-ENV او ما يسمى بيئة التعليم الذكية وهو تطبيق تعليمي لمساعدة الطلاب قام بتطويره (صهيب الطيب- Suhaib Eltayeb)

حدد نقاط الضعف في أداء الطالب بناءً على إجاباته على الأسئلة والدرس.

الأسئلة:
${questions.map((q) => ':السوال ${q.questionText}: الاجابة الصحيحة : ${q.correctAnswer} اجابة الطالب ${q.studentAnswer}').join('\n')}

الدرس:
$lesson

يجب أن يكون المخرج نصًا مُنسقًا بشكل جيد، مع تحديد نقاط الضعف بدقة ووضوح ومراجعتها سريعا مع الطالب .
''';

  String advicePrompt(List<Question> questions, String lesson) => '''
انت ميمو نموذج ذكاء اصطناعي كبير و معلم ذكي للطلاب من تطوير IL-ENV او ما يسمى بيئة التعليم الذكية وهو تطبيق تعليمي لمساعدة الطلاب قام بتطويره (صهيب الطيب- Suhaib Eltayeb)

قدم بعض النصائح للطالب لتحسين أدائه بناءً على إجاباته على الأسئلة والدرس.

الأسئلة:
${questions.map((q) => ':السوال ${q.questionText}: الاجابة الصحيحة : ${q.correctAnswer} اجابة الطالب ${q.studentAnswer}').join('\n')}

الدرس:
$lesson

يجب أن تكون النصائح مُفيدة ومُشجعة، مع التركيز على الجوانب التي يحتاج الطالب لتحسينها في الدرس.  يجب أن يكون المخرج نصًا مُنسقًا بشكل جيد.
اجعل اجابتك موجزة قدر الامكان
''';

  String generateFlashcardsPrompt(String lessonContent) => '''
انت ميمو نموذج ذكاء اصطناعي كبير من تطوير IL-ENV او ما يسمى بيئة التعليم الذكية وهو تطبيق تعليمي لمساعدة الطلاب قام بتطويره (صهيب الطيب- Suhaib Eltayeb)

قم بتوليد بطاقات حفظ (Flashcards) بناءً على محتوى الدرس التالي التزم بالنص الموجود في المحتوى:

$lessonContent

يجب أن تكون كل بطاقة حفظ عبارة عن زوج من السؤال والإجابة.  يجب أن يكون المخرج بتنسيق JSON، حيث يحتوي كل عنصر على "question" و "answer".

يجب أن يكون المخرج JSON فقط كما يلي:

```json
[
  {"question": "السؤال الأول", "answer": "الإجابة الأولى"},
  {"question": "السؤال الثاني", "answer": "الإجابة الثانية"},
  {"question": "السؤال الثالث", "answer": "الإجابة الثالثة"}
]
```
''';

//TODO (1): دالة prompt تاخذ الدرس و تولد البطاقات بتنسيق json
}

class AgentUtils {
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



Future<String?> extractTextFromImage(XFile? imageFile) async {
  try {
    if (imageFile == null) {
      return null;
    }

    final imageBytes = await imageFile.readAsBytes();

    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

    final apiKey = await Agent().getAPI(ModelType.gemini);
    if (apiKey == null) {
          debugPrint('خطاء في extractTextFromImage() : apiKey');

      return null;
    }

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    final content = Content.multi([
      TextPart('استخرج النص من هذه الصورة.'),
      DataPart(mimeType, imageBytes),
    ]);

    final response = await model.generateContent([content]);
    return response.text;
  } catch (e) {
    debugPrint('خطاء في extractTextFromImage(): $e');
    return null;
  }
}
