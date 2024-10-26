import 'package:get/get.dart';

import '../controllers/lesson_keys_controller.dart';

class LessonKeysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonKeysController>(
      () => LessonKeysController(),
    );
  }
}
