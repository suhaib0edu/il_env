import 'package:il_env/app/data/models/user_model.dart';
import 'package:il_env/app/data/repositories/auth_repository.dart';
import 'package:il_env/index.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  // متغيرات الحالة
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var user = Rxn<UserModel>();
  var errorMessage = ''.obs;
  var isRegistering = true.obs;


  // TextEditingControllers لحقول الإدخال
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    isLoggedIn.value = await authRepository.isLoggedIn();
    if (isLoggedIn.value) {
      user.value = await authRepository.getCurrentUser();
      navigateToHome();
    }
  }

  // دالة التسجيل
  Future<void> register() async {
    isLoading(true);
    errorMessage('');
    try {
      final newUser = await authRepository.register(
        emailController.text.trim(),
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
      if (newUser != null && newUser.token != null) {
        user.value = newUser;
        isLoggedIn.value = true;
        Get.snackbar(
          'تم التسجيل بنجاح',
          'مرحبا بك ${newUser.email}',
          backgroundColor: Colors.green,
        );
        navigateToHome();
      }
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('فشل التسجيل', e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  // دالة تسجيل الدخول
  Future<void> login() async {
    isLoading(true);
    errorMessage('');
    try {
      final loggedInUser = await authRepository.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (loggedInUser != null && loggedInUser.token != null) {
        user.value = loggedInUser;
        isLoggedIn.value = true;
        Get.snackbar(
          'تم تسجيل الدخول بنجاح',
          'مرحبا بعودتك ${emailController.text}',
          backgroundColor: Colors.green,
        );

        navigateToHome();
      }
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('فشل تسجيل الدخول', e.toString(),
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  // دالة تسجيل الخروج
  Future<void> logout() async {
    isLoading(true);
    errorMessage('');
    try {
      await authRepository.logout();
      isLoggedIn.value = false;
      user.value = null;
      Get.snackbar('تم تسجيل الخروج بنجاح', '', backgroundColor: Colors.green);
      navigateToAuth();
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('فشل تسجيل الخروج', e.toString(),
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  // دالة حذف الحساب
  Future<void> deleteAccount() async {
    isLoading(true);
    errorMessage('');
    try {
      await authRepository.deleteAccount();
      isLoggedIn.value = false;
      user.value = null;
      Get.snackbar('تم حذف الحساب بنجاح', '', backgroundColor: Colors.green);
      navigateToAuth();
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('فشل حذف الحساب', e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  // دالة تحديث الملف الشخصي
  Future<void> updateProfile() async {
    isLoading(true);
    errorMessage('');
    try {
      final updatedUser = await authRepository.updateProfile(
        usernameController.text.trim(),
        firstNameController.text.trim().isEmpty
            ? null
            : firstNameController.text.trim(),
        lastNameController.text.trim().isEmpty
            ? null
            : lastNameController.text.trim(),
      );
      if (updatedUser != null) {
        user.value = updatedUser;
        Get.snackbar('تم تحديث الملف الشخصي بنجاح', '',
            backgroundColor: Colors.green);
        navigateToHome();
      }
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('فشل تحديث الملف الشخصي', e.toString(),
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  void navigateToHome() {
    Get.offAllNamed(Routes.HOME);
  }

  void navigateToAuth() {
    Get.offAllNamed(Routes.AUTH);
  }

  @override
  void onClose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
