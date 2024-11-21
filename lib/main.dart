import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? langCode = await storage.read(key: 'language') ?? 'en';
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    GetMaterialApp(
      title: "IL-ENV",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      translations: TranslationsService(),
      locale: Locale(langCode),
      fallbackLocale: Locale('ar', 'SA'),
    ),
  );
}
