import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:il_env/app/utils/app_theme.dart';
import 'package:il_env/app/utils/lang.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "IL-ENV",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      translations: TranslationsService(),
      locale: Get.deviceLocale, 
      fallbackLocale: Locale('en', 'US'), 
      ),
  );
}
