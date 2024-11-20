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

  RxBool isVisibleOverallEvaluation = false.obs;
  RxBool isVisibleWeaknesses = false.obs;
  RxBool isVisibleAdvice = false.obs;

  void toggleVisibilityOverallEvaluation() {
    isVisibleOverallEvaluation.toggle();
    update(['overallEvaluation']);
  }

  void toggleVisibilityWeaknesses() {
    isVisibleWeaknesses.toggle();
    update(['weaknesses']);
  }

  void toggleVisibilityAdvice() {
    isVisibleAdvice.toggle();
    update(['advice']);
  }

  Future<void> loadExamData() async {
    try {
      final scoreJson = await storage.read(key: 'score');
      final questionsJson = await storage.read(key: 'questions');

      if (scoreJson != null) {
        score.value = int.parse(scoreJson);
      } else {
        print('Error: Score not found in storage. Using default value of 0.');
        score.value = 0; // Set a default value
      }

      if (questionsJson != null) {
        final questionsList = jsonDecode(questionsJson) as List<dynamic>;
        questions.value =
            questionsList.map((e) => Question.fromJson(e)).toList();
      } else {
        print('Error: Questions not found in storage. Using an empty list.');
        questions.value = []; // Set a default value
      }
    } catch (e) {
      print('Error loading exam data: $e');
    } finally {
      update();
    }
  }

  Future<void> generateEvaluation() async {
    isLoading.value = true;
    try {
      await loadExamData();
      final lesson = await storage.read(key: 'lesson') ?? '';

      final agent = Agent();
      final agentPrompts = AgentPrompts();

      // overallEvaluation.value = (await storage.read(key: 'overallEvaluation'))!;
      // weaknesses.value = (await storage.read(key: 'weaknesses'))!;
      // advice.value = (await storage.read(key: 'advice'))!;

      overallEvaluation.value = await agent.initiateChat(
          agentPrompts.overallEvaluationPrompt(score.value, questions, lesson),
          '');
      weaknesses.value = await agent.initiateChat(
          agentPrompts.weaknessesPrompt(questions, lesson), '');
      advice.value = await agent.initiateChat(
          agentPrompts.advicePrompt(questions, lesson), '');

      storage.write(key: 'overallEvaluation', value: overallEvaluation.value);
      storage.write(key: 'weaknesses', value: weaknesses.value);
      storage.write(key: 'advice', value: advice.value);
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
    generateEvaluation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
