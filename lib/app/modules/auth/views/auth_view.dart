import 'package:il_env/app/widgets/logo.dart';
import 'package:il_env/index.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isInstallPromptEnabled.value &&
              !controller.isInstalled.value) {
            return _buildInstallPWA();
          } else {
            // يمكنك هنا استدعاء الويدجت الخاص بواجهة تسجيل الدخول أو أي واجهة أخرى
            return _buildAuthView(context);
          }
        }),
      ),
    );
  }

  Widget _buildInstallPWA() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // شعار التطبيق (يمكن استبداله بصورة أخرى)
              Logo(), // مثال لشعار مؤقت
              SizedBox(height: 20),

              // العنوان الرئيسي الجذاب
              Text(
                translateKeyTr(TranslationKey.keyAddAppToHomeScreen),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                translateKeyTr(TranslationKey.keyFasterAccessBetterExperience),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 30),
              // قائمة الفوائد مع الأيقونات
              ListTile(
                leading: Icon(Icons.bolt, color: Colors.orange),
                title: Text(translateKeyTr(TranslationKey.keyInstantAccess)),
              ),
              ListTile(
                leading: Icon(Icons.library_books, color: Colors.green),
                title:
                    Text(translateKeyTr(TranslationKey.keyBetterOrganization)),
              ),
              ListTile(
                leading: Icon(Icons.wifi_off, color: Colors.blueGrey),
                title: Text(translateKeyTr(TranslationKey.keySaveData)),
              ),
              ListTile(
                leading: Icon(Icons.mobile_friendly, color: Colors.purple),
                title: Text(translateKeyTr(TranslationKey.keySmoothExperience)),
              ),
              SizedBox(height: 20),

              // زر التثبيت البارز
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.installPWA();
                  },
                  label: Text(translateKeyTr(TranslationKey.keyInstallNow),
                      style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // خيار التذكير لاحقًا
              TextButton(
                onPressed: () {
                  controller.isInstallPromptEnabled.value = false;
                },
                child: Text(translateKeyTr(TranslationKey.keyRemindLater)),
              ),
              SizedBox(height: 20),
              _buildLanguageButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthView(BuildContext context) {
    return SingleChildScrollView(
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
                  const Spacer(),
                  // حقل البريد الإلكتروني
                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: translateKeyTr(TranslationKey.keyEmail),
                      hintText:
                          translateKeyTr(TranslationKey.keyEnterYourEmail),
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
                        hintText:
                            translateKeyTr(TranslationKey.keyEnterYourPassword),
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
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.authAction(),
                          child: Text(
                            controller.isSignUp.value
                                ? translateKeyTr(TranslationKey.keySignUp)
                                : translateKeyTr(TranslationKey.keySignIn),
                            style: const TextStyle(color: Colors.white),
                          )),
                  const SizedBox(height: 20),
                  // زر التبديل بين تسجيل الدخول/الاشتراك
                  Center(
                    child: TextButton(
                      onPressed: () => controller.isSignUp.value =
                          !controller.isSignUp.value,
                      child: Text(
                        controller.isSignUp.value
                            ? translateKeyTr(
                                TranslationKey.keyAlreadyHaveAccount)
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
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const Spacer(),
                ],
              )),
        ),
      ),
    );
  }

  Widget myIcon(IconData icon) {
    return Icon(
      icon,
      color: AppColors.primaryColor,
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
