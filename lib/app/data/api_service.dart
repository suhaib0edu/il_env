import 'dart:typed_data';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:il_env/index.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'local_storage_service.dart';




class ApiService {
  final String _baseUrl = 'http://35.183.9.105:8000/api';
  final LocalStorageService _localStorageService = LocalStorageService();

  // دالة لإضافة Headers مع Token إذا كان متاحًا
  Future<Map<String, String>> _getHeaders() async {
    final token = await _localStorageService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Token $token';
    }
    return headers;
  }

  // دالة للتحقق من الاستجابة وإرجاع البيانات أو رمي استثناء
   dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
    
      if(response.body.isNotEmpty){
        try {
          debugPrint(response.body);
        return jsonDecode(response.body);
        }catch(e){
         return ;
        }
      } else {
        return ;
      }

    } else if(response.statusCode == 403){
        _localStorageService.deleteToken();
       throw Exception('غير مصرح. قد تحتاج إلى تسجيل الدخول مرة أخرى ${response.statusCode}');

    }
     else {
      try {
        final errorBody = jsonDecode(response.body);
        var errorMessage = errorBody is Map ? errorBody.values.first is List ?  errorBody.values.first.first : errorBody.values.first : 'حدث خطأ ما ${response.statusCode}';
      
         throw Exception('$errorMessage');
      } catch (e) {
         throw Exception('حدث خطأ ما ${response.statusCode}');
      }
    
    }
  }
  // دالة لتسجيل مستخدم جديد
  Future<dynamic> registerUser(String email, String username, String password) async {
    final url = Uri.parse('$_baseUrl/users/register/');
    final body = jsonEncode({'email': email, 'username': username, 'password': password});
    final headers = await _getHeaders();
    final response = await http.post(url, headers: headers, body: body);
    return _handleResponse(response);
  }

  // دالة لتسجيل دخول مستخدم
  Future<dynamic> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/login/');
    final body = jsonEncode({'email': email, 'password': password});
     final headers = await _getHeaders();
    final response = await http.post(url, headers: headers, body: body);
   
    return _handleResponse(response);
  }

  // دالة لتسجيل خروج المستخدم
   Future<dynamic> logoutUser() async {
    final url = Uri.parse('$_baseUrl/users/logout/');
    final headers = await _getHeaders();
    final response = await http.post(url, headers: headers);
    return _handleResponse(response);
  }

  // دالة لحذف حساب المستخدم
  Future<dynamic> deleteUser() async {
    final url = Uri.parse('$_baseUrl/users/delete/');
     final headers = await _getHeaders();
    final response = await http.delete(url,headers: headers);
    return _handleResponse(response);
  }

  // دالة لتحديث بيانات المستخدم
  Future<dynamic> updateUser(String username, String? firstName, String? lastName) async {
    final url = Uri.parse('$_baseUrl/users/update/');
    final body = jsonEncode({'username': username, 'first_name': firstName, 'last_name': lastName});
    final headers = await _getHeaders();
    final response = await http.put(url, headers: headers, body: body);
    return _handleResponse(response);
  }
}


Future<String?> extractTextFromImage(XFile? imagePath) async {
  try {
    Uint8List? imageBytes = await imagePath?.readAsBytes();
    if (imageBytes == null) {
      return null;
    }
    final agent = Agent();
    
    final apiKey = await agent.getAPI(await agent.getSelectedModel());
    debugPrint('weit ...');
    Gemini.init(apiKey: apiKey);
    Candidates? prompt = await Gemini.instance.prompt(parts: [
      Part.text('وظيفتك هي استخراج النصوص من الصور'),
      Part.uint8List(imageBytes)
    ]);
    return prompt?.output;
  } catch (e) {
    debugPrint("حدث خطأ: $e");
    return null;
  }
}
