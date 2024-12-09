import 'package:il_env/app/data/api_service.dart';
import 'package:il_env/index.dart';
import 'package:image_picker/image_picker.dart';

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
    if (lessonController.text.isNotEmpty) {
      storage.write(key: 'lesson', value: lessonController.text);
      Get.toNamed(Routes.STUDY_CENTER);
    } else {
      errorSnackbar(TranslationKey.keyLessonPrompt);
    }
  }

  void processImage(XFile? path) async {
    String? text = await extractTextFromImage(path);
    if (text != null) {
      String x = text;
      lessonController.text = x;
    } else {
      lessonController.text = '0';
    }
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      processImage(image);
    }
  }
}
