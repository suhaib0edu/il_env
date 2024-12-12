import 'package:get/get.dart';
import 'package:il_env/app/data/api_service.dart';
import 'package:il_env/app/data/local_storage_service.dart';
import 'package:il_env/app/modules/auth/controllers/auth_controller.dart';
import 'package:il_env/app/data/repositories/auth_repository.dart';
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => LocalStorageService());
    Get.lazyPut(() => AuthRepository(
          apiService: Get.find(),
          localStorageService: Get.find(),
        ));
    Get.lazyPut(
      () => AuthController(authRepository: Get.find()),
    );
  }
}