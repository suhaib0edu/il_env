import 'package:il_env/app/data/api_service.dart';
import 'package:il_env/app/data/local_storage_service.dart';
import 'package:il_env/app/data/models/user_model.dart';
import 'package:il_env/index.dart';

class AuthRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  AuthRepository({
    required ApiService apiService,
    required LocalStorageService localStorageService,
  })  : _apiService = apiService,
        _localStorageService = localStorageService;

  // التسجيل
  Future<UserModel?> register(
      String email, String username, String password) async {
    try {
      final response =
          await _apiService.registerUser(email, username, password);
      final user = UserModel.fromJson(response);
      if (user.token != null) {
        await _localStorageService.saveToken(user.token!);
      }
      return user;
    } catch (e) {
      // يمكنك إضافة سجلات هنا
      debugPrint('Error during registration: $e');
      rethrow;
    }
  }

  // تسجيل الدخول
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _apiService.loginUser(email, password);
      final user = UserModel.fromLoginJson(response);

      if (user.token != null) {
        await _localStorageService.saveToken(user.token!);
      }
      return user;
    } catch (e) {
      // يمكنك إضافة سجلات هنا
      debugPrint('Error during login: $e');
      rethrow;
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    try {
      await _apiService.logoutUser();
    } finally {
      await _localStorageService.deleteToken();
    }
  }

  // حذف الحساب
  Future<void> deleteAccount() async {
    try {
      await _apiService.deleteUser();
    } finally {
      await _localStorageService.deleteToken();
    }
  }

  // تحديث الملف الشخصي
  Future<UserModel?> updateProfile(
      String username, String? firstName, String? lastName) async {
    try {
      final response = await _apiService.updateUser(username, firstName, lastName);
       final user = UserModel.fromJson(response);
      if (user.token != null) {
         return user;
      }
        return null;

    } catch (e) {
       debugPrint('Error during update profile: $e');
      rethrow;
    }
  }

  // التحقق من حالة تسجيل الدخول
  Future<bool> isLoggedIn() async {
    final token = await _localStorageService.getToken();
    return token != null;
  }

   Future<UserModel?> getCurrentUser() async {
    final token = await _localStorageService.getToken();
    if(token != null){
         return UserModel(token: token);
    }
    return null;

  }
}