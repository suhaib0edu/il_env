import 'package:il_env/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  final isLoading = false.obs;
  final isSignUp = true.obs;
  final sessionError = ''.obs;
  final showPassword = false.obs;
  final isEN = false.obs;

  @override
  void onInit() async {
    super.onInit();
    _checkAuthSessionAndLang();
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
