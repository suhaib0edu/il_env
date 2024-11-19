import 'package:il_env/app/widgets/custom_spinKit_wave_spinner.dart';
import 'package:il_env/index.dart';
import '../controllers/exam_controller.dart';

class ExamView extends GetView<ExamController> {
  const ExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateKeyTr(TranslationKey.keyExam)),
        centerTitle: true,
      ),
      body: GetBuilder<ExamController>(builder: (ctr) {
        if (controller.questions.isEmpty) {
          // إضافة الأسئلة وتحديث الصفحة
          return _buildStartExamButton();
        }
        if (controller.isExamFinished.value) {
          // عرض النتيجة بعد انتهاء الاختبار
          return _buildExamResult();
        } else {
          // عرض الاختبار
          return _buildExamInProgress();
        }
      }),
    );
  }

  // جزء عرض زر بدء الاختبار
  Widget _buildStartExamButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Obx(()=> controller.isExamStarted.value
              ? CustomSpinKitWaveSpinner(size: 80,color: AppColors.primaryColor):SizedBox()),
          Spacer(),
          _buildExamResultActions(),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  // جزء عرض النتيجة بعد الاختبار
  Widget _buildExamResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "النتيجة النهائية: ${controller.score.value} من ${controller.questions.length}",
            style: TextStyle(fontSize: 22),
          ),
          Spacer(),
          _buildExamResultActions(),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  // جزء عرض الأزرار بعد إتمام الاختبار
  Widget _buildExamResultActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildResultButton(Icons.home_rounded, "الصفحة الرئيسية", controller.goToHome),
        _buildResultButton(Icons.quiz, "اختبار جديد", controller.createNewTest),
        _buildResultButton(Icons.refresh, "إعادة الاختبار", controller.loadLastTest),
      ],
    );
  }

  // جزء بناء الزر في النتيجة (إعادة الاختبار أو الصفحة الرئيسية)
  Widget _buildResultButton(IconData icon, String label, Function onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () => onPressed(),
          child: Icon(icon),
        ),
        Text(label),
      ],
    );
  }

  // جزء عرض الاختبار أثناء التقدم
  Widget _buildExamInProgress() {
    return Column(
      children: [
        // _buildAppBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuestionTitle(),
                SizedBox(height: 20),
                _buildQuestionContent(controller.currentQuestionIndex.value),
                Spacer(),
                _buildProgressBar(),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // جزء بناء عنوان السؤال
  Widget _buildQuestionTitle() {
    return Text(
      controller.questions[controller.currentQuestionIndex.value].questionText,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  // جزء بناء محتوى السؤال بناءً على نوعه
  Widget _buildQuestionContent(int questionIndex) {
    var question = controller.questions[questionIndex];
    switch (question.questionType) {
      case QuestionType.multipleChoice:
        return _buildMultipleChoiceQuestion(question);
      case QuestionType.trueFalse:
        return _buildTrueFalseQuestion(question);
      case QuestionType.essay:
        return _buildEssayQuestion(question);
      case QuestionType.comprehension:
        return _buildComprehensionQuestion(question);
      default:
        return Container();
    }
  }

  // جزء بناء شريط التقدم
  Widget _buildProgressBar() {
    return Column(
      children: [
        LinearProgressIndicator(value: controller.progressBar.value),
        SizedBox(height: 10),
        Text(
          'التقدم: ${(controller.progressBar.value * 100).toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // جزء بناء أزرار التنقل بين الأسئلة
  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: controller.previousQuestion,
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: controller.nextQuestion,
        ),
        ElevatedButton(
          onPressed: controller.submitExam,
          child: Text('تقديم الاختبار'),
        ),
      ],
    );
  }

  // جزء بناء الواجهة العلوية للتطبيق
  Widget _buildAppBar() {
    return Container(
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.tertiaryColor,
              ),
              onPressed: () => Get.back(),
            ),
            Expanded(
              child: Text(
                translateKeyTr(TranslationKey.keyExam),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.tertiaryColor),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.home_rounded,
                color: AppColors.tertiaryColor,
              ),
              onPressed: () => Get.toNamed(Routes.HOME),
            ),
          ],
        ),
      ),
    );
  }

  // بناء واجهة الأسئلة متعددة الخيارات
  Widget _buildMultipleChoiceQuestion(Question question) {
    return Column(
      children: question.options.map((option) {
        return _buildQuestionOption(option);
      }).toList(),
    );
  }

  // بناء واجهة السؤال صحيح/خطأ
  Widget _buildTrueFalseQuestion(Question question) {
    return Column(
      children: [
        _buildQuestionOption('صحيح'),
        _buildQuestionOption('خطأ'),
      ],
    );
  }

  // بناء واجهة السؤال المقال
  Widget _buildEssayQuestion(Question question) {
    return TextField(
      decoration: InputDecoration(labelText: 'اكتب إجابتك هنا'),
      onChanged: (value) {
        controller.selectedAnswers[controller.currentQuestionIndex.value] = value;
      },
    );
  }

  // بناء واجهة السؤال الفهم
  Widget _buildComprehensionQuestion(Question question) {
    return Column(
      children: question.options.map((option) {
        return _buildQuestionOption(option);
      }).toList(),
    );
  }

  // بناء واجهة الخيارات (تكرار الاستخدام)
  Widget _buildQuestionOption(String option) {
    return ListTile(
      title: Text(option),
      leading: Radio<String>(
        value: option,
        groupValue: controller.selectedAnswers[controller.currentQuestionIndex.value],
        onChanged: (value) {
          controller.selectAnswer(controller.currentQuestionIndex.value, value);
        },
      ),
    );
  }
}
