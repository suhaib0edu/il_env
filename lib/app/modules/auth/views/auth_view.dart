import 'package:il_env/app/widgets/logo.dart';
import 'package:il_env/index.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: Get.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      const Logo(),
                      const SizedBox(height: 30),
                      // حقل البريد الإلكتروني
                      TextFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: translateKeyTr(TranslationKey.keyEmail),
                          hintText: translateKeyTr(TranslationKey.keyEnterYourEmail),
                          prefixIcon: myIcon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // حقل كلمة المرور
                      Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          obscureText: !controller.showPassword.value,
                          decoration: InputDecoration(
                            labelText: translateKeyTr(TranslationKey.keyPassword),
                            hintText: translateKeyTr(TranslationKey.keyEnterYourPassword),
                            prefixIcon: myIcon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(controller.showPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => controller.showPassword.value =
                                  !controller.showPassword.value,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // زر تسجيل الدخول/الاشتراك
                      controller.isLoading.value
                          ? Center(
                              child: const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : CustomTextButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.authAction(),
                              text: controller.isSignUp.value
                                  ? translateKeyTr(TranslationKey.keySignUp)
                                  : translateKeyTr(TranslationKey.keySignIn),
                            ),
                      const SizedBox(height: 20),
                      // زر التبديل بين تسجيل الدخول/الاشتراك
                      Center(
                        child: TextButton(
                          onPressed: () => controller.isSignUp.value =
                              !controller.isSignUp.value,
                          child: Text(
                            controller.isSignUp.value
                                ? translateKeyTr(TranslationKey.keyAlreadyHaveAccount)
                                : translateKeyTr(TranslationKey.keyDontHaveAccount),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLanguageButton(),

                      // رسالة الخطأ
                      if (controller.sessionError.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red, width: 1),
                          ),
                          child: Text(
                            controller.sessionError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const Spacer(),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget myIcon(IconData icon) {
    return Icon(
      icon,
      color: AppColors.primaryColor.withOpacity(0.5),
    );
  }

  Widget _buildLanguageButton() {
    return Obx(() => Center(
      child: TextButton(
            onPressed: () => controller.toggleLanguage(),
            child: Text(
              controller.isEN.value ? 'عربي' : 'english',
              style: const TextStyle(fontSize: 16),
            ),
          ),
    ));
  }
}
