import 'package:il_env/index.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  void toggleLanguage() async {
  if (Get.locale?.languageCode == 'en') {
    await storage.write(key: 'language', value: 'ar');
    Get.updateLocale(Locale('ar', 'SA'));
  } else {
    await storage.write(key: 'language', value: 'en');
    Get.updateLocale(Locale('en', 'US'));
  }
}


}
