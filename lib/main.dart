import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? langCode = await storage.read(key: 'language') ?? 'en';

  runApp(
    GetMaterialApp(
      title: "IL-ENV",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      translations: TranslationsService(),
      locale: Locale(langCode),
      fallbackLocale: Locale('en', 'US'),
    ),
  );
}
