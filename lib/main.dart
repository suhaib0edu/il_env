import 'index.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Supabase.initialize(
    url: 'https://nftxtzjgwpidlthnsriz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5mdHh0empnd3BpZGx0aG5zcml6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ0Mjk3ODYsImV4cCI6MjA1MDAwNTc4Nn0.V5WTj8AfrvxDQ3w5D24wOAnVHj5tzen6eIxQRt9sMnI',
  );
  String? langCode = await storage.read(key: 'language') ?? 'ar';
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
