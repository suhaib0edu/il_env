import 'package:get/get.dart';

import '../controllers/policies_and_terms_controller.dart';

class PoliciesAndTermsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoliciesAndTermsController>(
      () => PoliciesAndTermsController(),
    );
  }
}
