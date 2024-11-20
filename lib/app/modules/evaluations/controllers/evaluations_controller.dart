import 'dart:convert';
import 'package:il_env/app/modules/exam/controllers/exam_controller.dart';
import 'package:il_env/index.dart';

class EvaluationsController extends GetxController {
  RxString overallEvaluation = ''.obs;
  RxString weaknesses = ''.obs;
  RxString advice = ''.obs;
  RxBool isLoading = false.obs;
  RxInt score = 0.obs;
  RxList<Question> questions = RxList<Question>();
  RxList<String?> selectedAnswers = RxList<String?>();


  Future<void> loadExamData() async {
    isLoading.value = true;
    try {
      final scoreJson = await storage.read(key: 'score');
      final questionsJson = await storage.read(key: 'questions');
      final selectedAnswersJson = await storage.read(key: 'selectedAnswers');

      if (scoreJson != null) {
        score.value = int.parse(scoreJson);
      } else {
        print('Error: Score not found in storage. Using default value of 0.');
        score.value = 0; // Set a default value
      }

      if (questionsJson != null) {
        final questionsList = jsonDecode(questionsJson) as List<dynamic>;
        questions.value = questionsList.map((e) => Question.fromJson(e)).toList();
      } else {
        print('Error: Questions not found in storage. Using an empty list.');
        questions.value = []; // Set a default value
      }

      if (selectedAnswersJson != null) {
        selectedAnswers.value = (jsonDecode(selectedAnswersJson) as List<dynamic>).cast<String?>();
      } else {
        print('Error: Selected Answers not found in storage. Using an empty list.');
        selectedAnswers.value = []; // Set a default value
      }

    } catch (e) {
      print('Error loading exam data: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> generateEvaluation() async {
    isLoading.value = true;
    try {
      final lesson = await storage.read(key: 'lesson') ?? '';

      final agent = Agent();
      final agentPrompts = AgentPrompts();

      overallEvaluation.value = await agent.initiateChat(
          agentPrompts.overallEvaluationPrompt(score.value), '');
      weaknesses.value = await agent.initiateChat(
          agentPrompts.weaknessesPrompt(questions.value, selectedAnswers.value, lesson), '');
      advice.value = await agent.initiateChat(
          agentPrompts.advicePrompt(questions.value, selectedAnswers.value, lesson), '');
    } catch (e) {
      print('Error generating evaluation: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadExamData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

// Question class and QuestionType enum remain unchanged (as they are already defined elsewhere)
