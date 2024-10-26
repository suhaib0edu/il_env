import 'package:il_env/index.dart';

class HomeController extends GetxController {
  final lessonController = TextEditingController();

  void toggleLanguage() async {
    if (Get.locale?.languageCode == 'en') {
      await storage.write(key: 'language', value: 'ar');
      Get.updateLocale(Locale('ar', 'SA'));
    } else {
      await storage.write(key: 'language', value: 'en');
      Get.updateLocale(Locale('en', 'US'));
    }
  }

  studyLessons() async {
//     String systemInstruction = '''
// اسمك هو (ميمي - Mimi) 
// انت عبارة عن نموذج لغة كبير وذكي تعمل حاليا كجزاء من تطبيق تعليمي (IL-ENV)
//  و يطلق عليه ايضا (بيئة  التعلم الذكية) 
//  الذي هو من تطوير (صهيب الطيب - Suhaib Eltayeb)
// ''';
    // Agent agent = Agent();
    // await agent.initiateChat(systemInstruction, questionController.text);

    Get.toNamed(Routes.LESSON_KEYS, arguments: [lessonController.text]);
    storage.write(key: 'lesson', value: lessonController.text);
  }
}
