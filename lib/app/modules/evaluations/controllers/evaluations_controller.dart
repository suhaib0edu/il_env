import 'package:get/get.dart';
import 'package:il_env/app/data/agent.dart';
import 'package:il_env/app/modules/exam/controllers/exam_controller.dart';
import 'package:il_env/index.dart'; // Import the index file

class EvaluationsController extends GetxController {
  RxString overallEvaluation = ''.obs;
  RxString weaknesses = ''.obs;
  RxString advice = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> generateEvaluation() async {
    isLoading.value = true;
    try {
      final examController = Get.find<ExamController>();
      final score = examController.score.value;
      final questions = examController.questions;
      final answers = examController.selectedAnswers;
      final lesson = await storage.read(key: 'lesson') ?? ''; // Use the imported storage

      final agent = Agent();
      final agentPrompts = AgentPrompts();

      overallEvaluation.value = await agent.initiateChat(
          agentPrompts.overallEvaluationPrompt(score), '');
      weaknesses.value = await agent.initiateChat(
          agentPrompts.weaknessesPrompt(questions, answers, lesson), '');
      advice.value = await agent.initiateChat(
          agentPrompts.advicePrompt(questions, answers, lesson), '');
    } catch (e) {
      print('Error generating evaluation: $e'); 
      // Handle error appropriately, e.g., show an error message
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    generateEvaluation();
  }

  @override
  void onClose() {}
}
