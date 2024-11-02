import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';
import '../models/user_info_response.dart';
import '../models/user_device_info_response.dart';

class WordPressService {
  final String baseUrl;

  WordPressService({required this.baseUrl});

  // 登入
  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wp-json/jwt-auth/v1/token'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return LoginResponse(
          success: true,
          token: data['token'],
          userEmail: data['user_email'],
          userNicename: data['user_nicename'],
          userDisplayName: data['user_display_name'],
        );
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        return LoginResponse(
          success: false,
          error: error['message'] ?? '登入失敗',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        error: '網路錯誤: ${e.toString()}',
      );
    }
  }

  // 獲取用戶信息
  Future<UserInfoResponse> getUserInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wp-json/wc/v3/customers/3'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserInfoResponse(
          success: true,
          id: data['id'],
          name: data['username'],
          email: data['email'],
          roles: data['role'],
        );
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        return UserInfoResponse(
          success: false,
          error: error['message'] ?? 'Failed to get user info',
        );
      }
    } catch (e) {
      return UserInfoResponse(
        success: false,
        error: 'Network error: ${e.toString()}',
      );
    }
  }

  // 獲取用戶設備信息
  Future<UserDeviceInfoResponse> getUserDeviceInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wp-json/wc/v3/customers/3/bluetooth-devices'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return UserDeviceInfoResponse.fromJsonList(jsonList);
      } else {
        return UserDeviceInfoResponse(
          devices: [],
          success: false,
          error: '取得設備資訊錯誤',
        );
      }
    } catch (e) {
      return UserDeviceInfoResponse(
        devices: [],
        success: false,
        error: '網路錯誤: ${e.toString()}',
      );
    }
  }

  // 驗證 Token
  Future<bool> validateToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wp-json/jwt-auth/v1/token/validate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
} 