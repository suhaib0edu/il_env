import 'package:il_env/index.dart';

import '../controllers/lesson_keys_controller.dart';

class LessonKeysView extends GetView<LessonKeysController> {
  const LessonKeysView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateKeyTr(TranslationKey.keyLessonBasicsTitle)),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isThinking.value
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          Text(translateKeyTr(TranslationKey.keyContentPreparation)),
                    ),
                  ],
                ),
              )
            : controller.coreConceptsContent.isEmpty
                ? Center(child: Text(translateKeyTr(TranslationKey.keyNoData)))
                : GetBuilder<LessonKeysController>(
                    builder: (controller) => ListView(
                      children: [
                        SizedBox(height: 20),
                        LessonKeysItems(
                            title: translateKeyTr(TranslationKey.keyMainGoals),
                            content: controller.mainGoalsContent),
                        LessonKeysItems(
                            title:
                                translateKeyTr(TranslationKey.keyCoreConcepts),
                            content: controller.coreConceptsContent),
                        LessonKeysItems(
                            title: translateKeyTr(
                                TranslationKey.keyImportantPoints),
                            content: controller.importantPointsContent),
                        // Center(
                        //   child: CustomTextButton(
                        //     text:
                        //         translateKeyTr(TranslationKey.keyStudyLessons),
                        //         onPressed: () => controller.goToDiscussion(),
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
