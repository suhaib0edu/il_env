import 'dart:convert';
import 'package:il_env/index.dart';

class FlashCardsController extends GetxController {
  List<Map<String, dynamic>> flashcards = <Map<String, dynamic>>[];
  final Agent agent = Agent();
  final AgentPrompts prompts = AgentPrompts();
  bool showAnswer = false;

  @override
  void onInit() {
    super.onInit();
    fetchFlashcards();
  }

  Future<void> fetchFlashcards() async {
    String lessonContent = await storage.read(key: 'lesson') ?? '';
    if (lessonContent.isEmpty) {
      print("Lesson content not found in storage.");
      return;
    }
    String flashcardDataJson = await agent.initiateChat(
        prompts.generateFlashcardsPrompt(lessonContent), "");
    try {
      final List<dynamic> flashcardList = jsonDecode(flashcardDataJson);
      flashcards = flashcardList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error parsing JSON: $e');
    }
    update([
      'flashcards',
    ]);
  }

  void toggleAnswer(int index) {
    showAnswer = !showAnswer;
    update(['flashcards', index]); 
  }
}
