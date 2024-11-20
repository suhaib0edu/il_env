import 'package:il_env/index.dart';

import '../controllers/study_center_controller.dart';

class StudyCenterView extends GetView<StudyCenterController> {
  const StudyCenterView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomContainer(
          color: Colors.black.withOpacity(0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCustomTextButton(text: 'مفاتيح الدرس',onPressed: () => Get.toNamed(Routes.LESSON_KEYS),),
              _buildCustomTextButton(text: 'ذاكر مع AI',onPressed: () => Get.toNamed(Routes.DISCUSSION),),
              _buildCustomTextButton(text: 'اختبرني',onPressed: () => Get.toNamed(Routes.EXAM),),
              _buildCustomTextButton(text: 'بطاقات الحفظ',onPressed: () => Get.toNamed(Routes.FLASH_CARDS),),
              _buildCustomTextButton(text: 'الصفحة الرئيسية',onPressed: () => Get.offAllNamed(Routes.HOME),),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextButton({required String text,void Function()? onPressed}) {
    return Padding(
      padding:  EdgeInsets.all(8.0),
      child: CustomTextButton(text: text,onPressed: onPressed,),
      
    );
  }
}
