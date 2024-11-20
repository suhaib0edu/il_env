import 'package:il_env/index.dart';

import '../controllers/study_center_controller.dart';

class StudyCenterView extends GetView<StudyCenterController> {
  const StudyCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomContainer(
          color: Colors.black.withOpacity(0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCustomTextButton(
                  text: translateKeyTr(TranslationKey.keyLessonKeys),
                  onPressed: () => Get.toNamed(Routes.LESSON_KEYS)),
              _buildCustomTextButton(
                  text: translateKeyTr(TranslationKey.keyStudyWithAI),
                  onPressed: () => Get.toNamed(Routes.DISCUSSION)),
              _buildCustomTextButton(
                  text: translateKeyTr(TranslationKey.keyTestMe),
                  onPressed: () => Get.toNamed(Routes.EXAM)),
              _buildCustomTextButton(
                  text: translateKeyTr(TranslationKey.keyFlashcards),
                  onPressed: () => Get.toNamed(Routes.FLASH_CARDS)),
              _buildCustomTextButton(
                  text: translateKeyTr(TranslationKey.keyHomePage),
                  onPressed: () => Get.offAllNamed(Routes.HOME)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextButton(
      {required String text, void Function()? onPressed}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: CustomTextButton(
        text: text,
        onPressed: onPressed,
      ),
    );
  }
}
