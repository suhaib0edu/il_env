import 'dart:convert';

import 'package:il_env/index.dart';

class LessonKeysController extends GetxController {
  String lesson = '';
  String mainGoalsContent = '';
  String coreConceptsContent = '';
  String importantPointsContent = '';

  RxBool isThinking = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    try {
      lesson = Get.arguments[0];
      getLessonKeys();
    } catch (e) {
      try {
        lesson = await storage.read(key: 'lesson') ?? '';
        getLessonKeys();
      } catch (e) {
        lesson = '';
        errorSnackbar(TranslationKey.keyCheckConnection);
        Get.toNamed(Routes.HOME);
      }
    }
  }

  getLessonKeys() async {
    isThinking.value = true;
    Agent agent = Agent();
    String systemInstruction = AgentUtils().lessonKeysPrompt();
    var response = await agent.initiateChat(systemInstruction, lesson);
    var data = jsonDecode(response);

    // Extract data from the JSON response
    mainGoalsContent = AgentUtils().formatObjectivesAsMarkdown(
        data['summary']['lesson_objectives']);
    coreConceptsContent = AgentUtils().formatObjectivesAsMarkdown(
        data['summary']['key_concepts']);
    importantPointsContent = AgentUtils().formatObjectivesAsMarkdown(
        data['summary']['important_points']);

    isThinking.value = false;
    update(); 
  }

  goToDiscussion() {
    Get.toNamed(Routes.DISCUSSION, arguments: [lesson]);
  }
}
