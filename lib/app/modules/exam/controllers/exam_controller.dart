import 'dart:convert';
import 'package:il_env/index.dart';

class ExamController extends GetxController {
  // 1. قائمة الأسئلة
  RxList<Question> questions = RxList<Question>();

  // 2. الإجابات المختارة
  RxList<String?> selectedAnswers =
      RxList<String?>.filled(10, null, growable: true);

  // 3. الوقت المتبقي
  RxInt remainingTime = 900.obs; // 15 دقيقة بالثواني (15 * 60)

  // 4. التقدم
  RxDouble progressBar = 0.0.obs;

  // 5. النتيجة
  RxInt score = 0.obs;

  // 6. مؤشر السؤال الحالي
  RxInt currentQuestionIndex = 0.obs;

  // 7. حالة الاختبار و اعداد الاختبار
  RxBool isExamFinished = false.obs;
  RxBool isExamStarted = false.obs;

  // 8. وقت البدء
  // late Timer timer;

  // 9. الوقت المتبقي
  // void startTimer() {
  //   timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (remainingTime.value > 0) {
  //       remainingTime.value--;
  //     } else {
  //       stopTimer();
  //       submitExam(); // إرسال الاختبار عند انتهاء الوقت
  //     }
  //   });
  // }

  // 10. البدء في الاختبار
  void startExam() {
    // عند الضغط عليه تظهر الأسئلة ويبدأ الاختبار
    // startTimer();
  }

  // 11. التقدم إلى السؤال التالي
  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      updateProgress();
    }
  }

  // 12. الرجوع إلى السؤال السابق
  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      updateProgress();
    }
  }

  // 13. اختيار إجابة
  void selectAnswer(int questionIndex, String? answer) {
    selectedAnswers[questionIndex] = answer;
    update();
  }

  // 14. تحديث التقدم
  void updateProgress() {
    progressBar.value = (currentQuestionIndex.value + 1) / questions.length;
    update();
  }

  // 15. إرسال الاختبار
  void submitExam() {
    try {
      isExamFinished.value = true;
      evaluateAnswers();
      // stopTimer();
    } catch (e) {
      debugPrint('Error submitting exam: $e');
    }
    update();
  }

  // 16. تقييم الإجابات
  void evaluateAnswers() {
    try {
      score.value = 0;
      if (selectedAnswers[0] != null) {
        for (int i = 0; i < questions.length; i++) {
          if (selectedAnswers[i] != null) {
            if (selectedAnswers[i] == questions[i].correctAnswer) {
              score.value++;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error evaluating answers: $e');
    }
    update();
  }

  // 17. إيقاف التوقيت
  void stopTimer() {
    // timer.cancel();
  }

  // 18. عرض النتيجة النهائية
  void showFinalScore() {
    print("Your final score is: ${score.value} out of ${questions.length}");
  }

  // 19. إضافة بيانات الاختبار
  void createNewTest() async {
    try {
      isExamStarted.value = true;
      currentQuestionIndex = 0.obs;
      // محاولة جلب الأسئلة من الذاكرة المحلية
      var localQuestions = null;
      // localQuestions = await storage.read(key: 'questions');

      // إذا كانت الأسئلة غير موجودة في الذاكرة المحلية
      if (localQuestions == null) {
        String lesson =
            await storage.read(key: 'lesson') ?? ''; // قراءة الدرس من الذاكرة
        if (lesson.isEmpty) {
          debugPrint('No lesson found in local storage.');
          return; // إذا لم يكن هناك درس، نخرج من الدالة
        }

        String systemInstruction =
            AgentPrompts().makerQuestionsPrompt(); // إعداد تعليمات النظام
        Agent agent = Agent();

        // إرسال طلب إلى العميل للحصول على الأسئلة
        var response = await agent.initiateChat(systemInstruction, lesson);
        var data = jsonDecode(response);

        // التحقق من أن الاستجابة تحتوي على الأسئلة
        if (data['questions'] != null) {
          var questionsList = data['questions'];
          questions.clear(); // مسح الأسئلة الحالية

          // تخزين الأسئلة في الذاكرة المحلية
          await storage.write(
              key: 'questions', value: jsonEncode(questionsList));
          debugPrint('Questions fetched and saved locally.');

          // تحويل البيانات إلى قائمة من الأسئلة
          _populateQuestions(questionsList);
        } else {
          debugPrint('No questions found in the response.');
        }
      } else {
        debugPrint('Questions already exist in local storage.');
      }
      isExamStarted.value = false;

      // تحديث واجهة المستخدم
      update();
    } catch (e) {
      // التعامل مع الأخطاء وتسجيلها
      debugPrint('Error fetching or processing questions: $e');
    }
    isExamFinished.value = false;
    update();
  }

  void loadLastTest() async {
    try {
      // محاولة جلب الأسئلة من الذاكرة المحلية
      var localQuestions = await storage.read(key: 'questions');

      // إذا كانت الأسئلة موجودة في الذاكرة المحلية
      if (localQuestions != null) {
        print('Loading questions from local storage.');
        questions.clear(); // مسح الأسئلة الحالية
        var questionsList = jsonDecode(localQuestions);

        // تحويل البيانات إلى قائمة من الأسئلة
        _populateQuestions(questionsList);
      } else {
        debugPrint('No questions found in local storage.');
        createNewTest();
      }

      // تحديث واجهة المستخدم
      update();
    } catch (e) {
      // التعامل مع الأخطاء وتسجيلها
      debugPrint('Error loading questions: $e');
      createNewTest();
    }
    isExamFinished.value = false;
    update();
  }

// دالة لتحويل البيانات إلى قائمة من الأسئلة
  void _populateQuestions(List<dynamic> questionsList) {
    for (var questionData in questionsList) {
      Question question = Question(
        questionText: questionData['questionText'],
        options: List<String>.from(questionData['options']),
        correctAnswer: questionData['correctAnswer'],
        questionType: getQuestionType(questionData['questionType']),
      );
      questions.add(question);
    }
  }

  void goToHome() {
    Get.toNamed(Routes.HOME);
  }

  @override
  void onInit() {
    super.onInit();
    // makeQuestions();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    stopTimer();
    questions.clear();
    selectedAnswers.clear();
    remainingTime.value = 900;
    progressBar.value = 0.0;
    score.value = 0;
    currentQuestionIndex.value = 0;
    isExamFinished.value = false;
  }

  QuestionType getQuestionType(questionData) {
    switch (questionData) {
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'trueFalse':
        return QuestionType.trueFalse;
      case 'essay':
        return QuestionType.essay;
      case 'comprehension':
        return QuestionType.comprehension;
      default:
        return QuestionType.multipleChoice;
    }
  }
}

class Question {
  String questionText;
  List<String> options;
  String correctAnswer;
  String? studentAnswer;
  QuestionType questionType;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.questionType,
    this.studentAnswer,
  });
}

enum QuestionType {
  multipleChoice, // أسئلة متعددة الخيارات
  trueFalse, // أسئلة صحيح/خطأ
  essay, // أسئلة مقال
  matching, // أسئلة تصنيف
  comprehension, // اختبار الفهم
}
