import 'package:get/get.dart';

import '../controllers/study_center_controller.dart';

class StudyCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudyCenterController>(
      () => StudyCenterController(),
    );
  }
}
