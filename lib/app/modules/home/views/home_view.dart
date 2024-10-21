import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:il_env/app/routes/app_pages.dart';
import 'package:il_env/app/utils/colors.dart';
import 'package:il_env/app/widgets/custom_container.dart';
import '../controllers/home_controller.dart';
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: toggleLanguage,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(
                        side: BorderSide(
                            color: AppColors.primaryColor, width: 1)),
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(Icons.language, color: AppColors.primaryColor),
                ),
                ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.SETTINGS),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(
                        side: BorderSide(
                            color: AppColors.primaryColor, width: 1)),
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(Icons.settings, color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 90),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(
                  height: 90,
                  width: 90,
                  color: AppColors.tertiaryColor,
                ),
              ],
            ),
            SizedBox(height: 70),
            Center(child: Text('help_text'.tr)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'question_hint'.tr, 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 70),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'study_lessons'.tr, 
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    void toggleLanguage() {
    if (Get.locale?.languageCode == 'en') {
      Get.updateLocale(Locale('ar', 'SA'));
    } else {
      Get.updateLocale(Locale('en', 'US'));
    }
  }
}
