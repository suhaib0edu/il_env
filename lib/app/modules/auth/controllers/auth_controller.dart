import 'package:il_env/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:html';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  final isLoading = false.obs;
  final isSignUp = true.obs;
  final sessionError = ''.obs;
  final showPassword = false.obs;
  final isEN = false.obs;

  BeforeInstallPromptEvent? _installPromptEvent;
  final RxBool _showInstallPrompt = false.obs;
  bool get showInstallPrompt => _showInstallPrompt.value;

  @override
  void onInit() async {
    super.onInit();
    _listenForInstallPrompt();
    // _showInstallPrompt.value = true; // اعرض الزر دائمًا مؤقتًا
    _checkAuthSessionAndLang();
  }



  void _listenForInstallPrompt() {
    print('0');
    window.addEventListener('beforeinstallprompt', (e) {
      print('1 - beforeinstallprompt event fired');
      e.preventDefault();
      _installPromptEvent = e as BeforeInstallPromptEvent;
      _showInstallPrompt.value = true;
      update();
    });
  }

  void installPWA() async {
    print('2');
    if (_installPromptEvent != null) {
      _installPromptEvent!.prompt();
      final Map<String, dynamic>? choiceResult = await _installPromptEvent!.userChoice;
      if (choiceResult != null && choiceResult['outcome'] == 'accepted') {
        print('تم تثبيت التطبيق بنجاح');
        _showInstallPrompt.value = false;
        update();
      } else {
        print('تم رفض تثبيت التطبيق أو حدث خطأ');
      }
      _installPromptEvent = null;
    } else {
      print('Error: _installPromptEvent is null. The beforeinstallprompt event might not have fired.');
    }
    print('000');
  }


  Future<void> _checkAuthSessionAndLang() async {
    await storage.read(key: 'language').then((value) {
      if (value == 'ar') {
        isEN.value = false;
      } else {
        isEN.value = true;
      }
    });
    final session = supabase.auth.currentSession;
    if (session != null) {
      Get.toNamed(Routes.HOME);
    }
  }

  Future<void> signUp() async {
    isLoading.value = true;
    sessionError.value = '';
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (res.user != null) {
        await signIn();
      } else if (res.session != null) {
        Get.offAllNamed(Routes.HOME);
      }
    } on AuthException catch (e) {
      sessionError.value = _mapAuthExceptionToMessage(e);
    } catch (e) {
      sessionError.value = 'حدث خطأ غير متوقع';
      print('Error during signup: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn() async {
    isLoading.value = true;
    sessionError.value = '';
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (res.session != null || res.user != null) {
        Get.offAllNamed(Routes.HOME);
      }
    } on AuthException catch (e) {
      sessionError.value = _mapAuthExceptionToMessage(e);
    } catch (e) {
      sessionError.value = translateKeyTr(TranslationKey.keyAuthError);
      debugPrint('Error during signin: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> authAction() async {
    if (isSignUp.value) {
      await signUp();
    } else {
      await signIn();
    }
  }

  String _mapAuthExceptionToMessage(AuthException e) {
    print('error: ${e.message}');

    switch (e.message) {
      case 'Invalid login credentials':
        return translateKeyTr(TranslationKey.keyInvalidCredentials);
      case 'User already registered':
        return translateKeyTr(TranslationKey.keyUserAlreadyRegistered);
      case 'Password should be at least 6 characters.':
        return translateKeyTr(TranslationKey.keyWeakPassword);
      case 'Email not confirmed':
        return translateKeyTr(TranslationKey.keyEmailNotConfirmed);
      default:
        return translateKeyTr(TranslationKey.keyAuthError);
    }
  }

  void toggleLanguage() {
    isEN.toggle();
    toggleLanguageFun();
  }

  // Future<void> signOut() async {
  //   await supabase.auth.signOut();
  //   Get.offAllNamed(Routes.AUTH);
  // }
}
