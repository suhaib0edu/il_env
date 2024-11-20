import 'package:get/get.dart';

import '../controllers/flash_cards_controller.dart';

class FlashCardsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlashCardsController>(
      () => FlashCardsController(),
    );
  }
}
