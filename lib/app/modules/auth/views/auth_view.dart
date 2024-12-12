import 'package:il_env/app/modules/auth/controllers/auth_controller.dart';
import 'package:il_env/index.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          //لتمكين التمرير إذا كانت لوحة المفاتيح ترفع المحتوى
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => controller.isLoading.value
                ? const CustomSpinKitWaveSpinner() // عرض مؤشر التحميل
                : Card(
                  color: AppColors.secondaryColor.withOpacity(0.5),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // لتجنب امتداد العمود
                        children: <Widget>[
                          // التبديل بين التسجيل وتسجيل الدخول
                          SegmentedButton<bool>(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tertiaryColor,
                            ),
                            segments: const <ButtonSegment<bool>>[
                              ButtonSegment<bool>(
                                value: true,
                                label: Text('تسجيل'),
                              ),
                              ButtonSegment<bool>(
                                value: false,
                                label: Text('تسجيل الدخول'),
                              ),
                            ],
                            selected: <bool>{controller.isRegistering.value},
                            onSelectionChanged: (Set<bool> newSelection) {
                              controller.isRegistering.value =
                                  newSelection.first;
                            },
                          ),
                          const SizedBox(height: 20),

                          // حقول الإدخال
                          if (controller.isRegistering.value)
                            CustomTextField(
                              controller: controller.usernameController,
                              labelText: 'اسم المستخدم',
                              suffixIcon: Icon(Icons.person),
                              maxLines: 1,
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CustomTextField(
                              controller: controller.emailController,
                              labelText: 'البريد الإلكتروني',
                              suffixIcon: Icon(Icons.email),
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                            ),
                          ),
                          CustomTextField(
                            controller: controller.passwordController,
                            labelText: 'كلمة المرور',
                            suffixIcon: Icon(Icons.lock),
                            obscureText: true, // لإخفاء كلمة المرور
                            maxLines: 1,
                          ),
                            const SizedBox(height: 20),
                          if (controller.isRegistering.value)
                            CustomTextButton(
                              text: 'تسجيل',
                              onPressed: controller.register,
                            )
                          else
                            CustomTextButton(
                              text: 'تسجيل الدخول',
                              onPressed: controller.login,
                            ),
                          // if (controller.errorMessage
                          //     .isNotEmpty) // عرض رسالة الخطأ إذا كانت موجودة
                          //   Text(
                          //     controller.errorMessage.value,
                          //     style: const TextStyle(color: Colors.red),
                          //   ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
