import 'package:il_env/index.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLanguageButton(),
                _buildSettingsButton(),
              ],
            ),
            const SizedBox(height: 90),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogoApp(),
              ],
            ),
            const SizedBox(height: 70),
            Center(
              child: Text(
                translateKeyTr(TranslationKey.keyHelpText),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildQuestionTextField(),
            const SizedBox(height: 70),
            Center(
              child: _buildStudyLessonsButton(controller),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton() {
    return ElevatedButton(
      onPressed: controller.toggleLanguage,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(
          side: BorderSide(color: AppColors.primaryColor, width: 1),
        ),
        padding: EdgeInsets.all(10),
      ),
      child: Icon(Icons.language, color: AppColors.primaryColor),
    );
  }

  Widget _buildSettingsButton() {
    return ElevatedButton(
      onPressed: () => Get.toNamed(Routes.SETTINGS),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(
          side: BorderSide(color: AppColors.primaryColor, width: 1),
        ),
        padding: EdgeInsets.all(10),
      ),
      child: Icon(Icons.settings, color: AppColors.primaryColor),
    );
  }

  Widget _buildLogoApp() {
    return CustomContainer(
      height: 90,
      width: 90,
      color: AppColors.tertiaryColor,
    );
  }

  Widget _buildQuestionTextField() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: CustomTextField(
          controller: controller.lessonController,
          labelText: translateKeyTr(TranslationKey.keyLessonPrompt),
          maxLength: 3500,
        ));
  }

  Widget _buildStudyLessonsButton(HomeController controller) {
    return CustomTextButton(
      text: translateKeyTr(TranslationKey.keyStudyLessons),
      onPressed: controller.studyLessons,
    );
  }
}
