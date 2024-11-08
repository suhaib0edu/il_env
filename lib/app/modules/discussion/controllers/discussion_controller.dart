import 'dart:convert';
import 'package:il_env/index.dart';

class DiscussionController extends GetxController {
  bool isMakingRequest = false;
  bool isThinking = false;
  bool showdeepExplanation = false;
  bool showExploreQuestions = false;
  bool showDirectQuestion = false;
  String lesson = '';
  List<Map<String, dynamic>> contentParts = [];
  int currentPart = 1;
  int currentDeepExplanation = 0;
  int currentExploreQuestion = 0;
  int currentDirectQuestion = 0;
  TextEditingController directQuestionController = TextEditingController();

  // خريطة لتخزين الشروحات العميقة حسب الجزء
  Map<int, List<dynamic>> deepExplanationMap = <int, List<dynamic>>{};
  // خريطة لتخزين الأسئلة الاستكشافية حسب الجزء
  Map<int, List<dynamic>> exploreQuestionsMap = <int, List<dynamic>>{};
  // خريطة لتخزين الأسئلة المباشرة حسب الجزء
  Map<int, List<dynamic>> directQuestionMap = <int, List<dynamic>>{};

  // دالة التهيئة
  @override
  void onInit() async {
    super.onInit();
    try {
      lesson = Get.arguments[0];
      lessonDivider();
    } catch (e) {
      try {
        lesson = await storage.read(key: 'lesson') ?? '';
        lessonDivider();
      } catch (e) {
        lesson = '';
        errorSnackbar(TranslationKey.keyCheckConnection);
        Get.toNamed(Routes.HOME);
      }
    }
  }

  // دالة تقسيم الدرس
  lessonDivider() async {
    try {
      isMakingRequest = true;
      update(['discussionView']);
      Agent agent = Agent();
      String systemInstruction = AgentUtils().lessonDividerPrompt();
      var response = await agent.initiateChat(systemInstruction, lesson);
      var data = jsonDecode(response);
      var parts = data['content_parts'];

      // String? jsonString = await storage.read(key: 'contentParts');
      // if (jsonString != null) {
      //   List<dynamic> jsonData = jsonDecode(jsonString);
      //   contentParts = List<Map<String, dynamic>>.from(jsonData);
      // }

      parts.forEach((element) {
        contentParts.add(element);
      });
      await storage.write(key: 'contentParts', value: jsonEncode(contentParts));
    } catch (e) {
      debugPrint(e.toString());
    }
    isMakingRequest = false;
    update(['discussionView']);
  }

  void deepExplanation() async {
    try {
      isThinking = true;
      update(['buildRequestIndicator']);
      Agent agent = Agent();
      String systemInstruction = AgentUtils().deepExplanationPrompt();

      agent
          .initiateChat(systemInstruction, contentParts[currentPart - 1]['c'])
          .then((value) {
        if (!deepExplanationMap.containsKey(currentPart)) {
          deepExplanationMap[currentPart] = [];
        }
        deepExplanationMap[currentPart]!.add(value);
        // storage.write(
        //     key: 'deepExplanationMap', value: jsonEncode(deepExplanationMap));
      }).whenComplete(() {
        isThinking = false;
        update(['deepExplanationControls', 'buildRequestIndicator']);
      });

      // var x = await storage.read(key: 'deepExplanationMap');
      //   print(x);
      // if (x != null) {
      //   deepExplanationMap = jsonDecode(x);
      // }
      // isThinking = false;
      // update(['deepExplanationControls', 'buildRequestIndicator']);
    } catch (e) {
      debugPrint(e.toString());
      isThinking = false;
      update(['deepExplanationControls', 'buildRequestIndicator']);
    }
  }

  void exploreQuestions() {
    try {
      isThinking = true;
      update(['buildRequestIndicator']);
      Agent agent = Agent();
      String systemInstruction = AgentUtils()
          .exploreQuestionsPrompt(part: contentParts[currentPart - 1],oldQuestions: exploreQuestionsMap[currentPart]);
      agent
          .initiateChat(systemInstruction, contentParts[currentPart - 1]['c'])
          .then((value) {
        if (!exploreQuestionsMap.containsKey(currentPart)) {
          exploreQuestionsMap[currentPart] = [];
        }
        exploreQuestionsMap[currentPart]!.add(value);
      }).whenComplete(() {
        isThinking = false;
        update(['exploreQuestionsControls', 'buildRequestIndicator']);
      });
    } catch (e) {
      debugPrint(e.toString());
      isThinking = false;
      update(['exploreQuestionsControls', 'buildRequestIndicator']);
    }
  }

  void directQuestion() {
    Get.back(); 
    try {
      isThinking = true;
      update(['buildRequestIndicator']);
      Agent agent = Agent();
      String systemInstruction = AgentUtils()
          .directQuestionPrompt(part: contentParts[currentPart - 1]);
      agent
          .initiateChat(systemInstruction, directQuestionController.text)
          .then((value) {
        if (!directQuestionMap.containsKey(currentPart)) {
          directQuestionMap[currentPart] = [];
        }
        directQuestionMap[currentPart]!.add(value);
      }).whenComplete(() {
        isThinking = false;
        update(['directQuestionsControls', 'buildRequestIndicator']);
      });
    } catch (e) {
      debugPrint(e.toString());
      isThinking = false;
      update(['exploreQuestionsControls', 'buildRequestIndicator']);
    }
  }

  next() {
    if (currentPart < contentParts.length) {
      currentPart++;
      currentValueToZero();
      update(['discussionView']);
    }
  }

  previous() {
    if (currentPart > 1) {
      currentPart--;
      currentValueToZero();
      update(['discussionView']);
    }
  }

  currentValueToZero() {
    currentDeepExplanation = 0;
    currentExploreQuestion = 0;
    currentDirectQuestion = 0;
    showdeepExplanation = false;
    showExploreQuestions = false;
    showDirectQuestion = false;
    update(['deepExplanationControls']);
  }
}
