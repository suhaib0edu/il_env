import 'package:il_env/app/data/api_service.dart';
import 'package:il_env/index.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  final lessonController = TextEditingController();
  bool isLoading = false;
  RxBool haveLesson = false.obs;

  @override
  void onInit() async {
    super.onInit();
    checkUpdate();
  }

  Future<void> checkUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      // await remoteConfig.setConfigSettings(RemoteConfigSettings(
      //   fetchTimeout: const Duration(seconds: 10),
      //   minimumFetchInterval: const Duration(seconds: 20),
      // ));

      await remoteConfig.setDefaults(const {
        'checkUpdate':
            '{"minimal_version":"1.0.0","latest_version":"1.0.0","update_url":"https://il-env.web.app/","force_update":false,"update_message":"متوفر تحديث جديد"}',
      });

      await remoteConfig.fetchAndActivate();

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      debugPrint('packageInfo version: ${packageInfo.version}');
      String currentVersion = packageInfo.version;
      final x = remoteConfig.getAll();
      x.forEach((key, value) {
        debugPrint('key: $key, value: ${value.asString()}');
      });

      final updateInfoString = remoteConfig.getString('checkUpdate');
      final Map<String, dynamic> updateInfo = jsonDecode(updateInfoString);
      debugPrint('latest_version: ${updateInfo['latest_version']}');

      String minimalVersion = updateInfo['minimal_version'];
      String latestVersion = updateInfo['latest_version'];
      String updateUrl = updateInfo['update_url'];
      bool forceUpdate = updateInfo['force_update'];
      String updateMessage = updateInfo['update_message'];

      if (int.parse(currentVersion.replaceAll('.', '')) <
              int.parse(minimalVersion.replaceAll('.', '')) &&
          forceUpdate) {
        Get.defaultDialog(
          title: translateKeyTr(TranslationKey.keyUpdateRequired),
          middleText: updateMessage,
          barrierDismissible: false,
          onConfirm: () async {
            await launchUrl(Uri.parse(updateUrl));
            Get.back();
          },
          textConfirm: translateKeyTr(TranslationKey.keyUpdate),
        );
      } else if (int.parse(currentVersion.replaceAll('.', '')) <
          int.parse(latestVersion.replaceAll('.', ''))) {
        Get.defaultDialog(
          title: translateKeyTr(TranslationKey.keyUpdateAvailable),
          middleText: updateMessage,
          onConfirm: () async {
            await launchUrl(Uri.parse(updateUrl));
            Get.back();
          },
          onCancel: () => Get.back(),
          textConfirm: translateKeyTr(TranslationKey.keyUpdate),
          textCancel: translateKeyTr(TranslationKey.keyLater),
        );
      }
    } catch (e) {
      debugPrint("خطاء في دالة checkUpdate(): $e");
    }
  }
  

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
