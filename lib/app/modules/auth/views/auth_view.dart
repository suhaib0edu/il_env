import '../controllers/auth_controller.dart';
import 'package:il_env/index.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    print('object');
    return Scaffold(
      body: Center(
        child: Obx(() => controller.isLoading.value
            ? const CircularProgressIndicator()
            : CustomTextButton(
                onPressed: () async {
                  await controller.signInWithGoogle();
                },
                text: translateKeyTr(TranslationKey.keySignInWithGoogle),
              )),
      ),
    );
  }
}
