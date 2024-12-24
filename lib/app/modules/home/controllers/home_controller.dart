import 'package:il_env/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pwa_install/pwa_install.dart';

class HomeController extends GetxController {
  final lessonController = TextEditingController();
  bool isLoading = false;
  RxBool haveLesson = false.obs;

  @override
  void onInit() {
    super.onInit();
    initPWAInstall();
  }

  void initPWAInstall() {
    PWAInstall().setup(installCallback: () {
      Get.snackbar(
        translateKeyTr(TranslationKey.keyInstalling),
        translateKeyTr(TranslationKey.keyCheckNotificationProgress),
      );
    });
    PWAInstall().getLaunchMode_();
    if (PWAInstall().installPromptEnabled) {
      installPWA();
    }
  }

  void installPWA() {
    try {
      PWAInstall().promptInstall_();
    } catch (e) {
      Get.snackbar(
        translateKeyTr(TranslationKey.keyError),
        translateKeyTr(TranslationKey.keyInstallNotSupported),
      );
    }
  }

  void toggleLanguage() => toggleLanguageFun();

  studyLessons() async {
    if (lessonController.text.isNotEmpty) {
      storage.write(key: 'lesson', value: lessonController.text);
      Get.toNamed(Routes.STUDY_CENTER);
    } else {
      errorSnackbar(TranslationKey.keyLessonPrompt);
    }
  }

  void processImage(XFile? path) async {
    isLoading = true;
    update();
    String? text = await extractTextFromImage(path);
    if (text != null) {
      String x = text;
      lessonController.text = x;
      haveLesson.value = true;
    } else {
      lessonController.text = '0';
    }

    isLoading = false;
    update();
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      processImage(image);
    }
  }

  haveLessonFun(value) {
    haveLesson.value = value.length > 5;
  }
}
