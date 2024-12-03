import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';
import '../models/user_info_response.dart';
import '../models/user_device_info_response.dart';
import '../models/register_response.dart';
import '../../config/app_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class WordPressService {
  WordPressService();

  // 登入
  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/wp-json/jwt-auth/v1/token'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
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
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['data']['user']['id'];

      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}/wp-json/wc/v3/customers/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('===========getuserinfo================');
        print(data);
        return UserInfoResponse(
          success: true,
          id: data['id'],
          name: data['username'],
          email: data['email'],
          roles: data['role'],
        );
      } else {
        print('===========getuserinfo================');
        print('error');
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
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['data']['user']['id'];

      final response = await http.get(
        Uri.parse(
            '${dotenv.env['BASE_URL']}/wp-json/wc/v3/customers/$userId/bluetooth-devices'),
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
        Uri.parse(
            '${dotenv.env['BASE_URL']}/wp-json/jwt-auth/v1/token/validate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 註冊
  Future<RegisterResponse> register({
    required String email,
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    try {
      final String apiUrl = '${dotenv.env['BASE_URL']}/wp-json/wc/v3/customers';
      print(apiUrl);
      String basicAuth = base64Encode(utf8.encode(
          '${dotenv.env['CONSUMER_KEY']}:${dotenv.env['CONSUMER_SECRET']}'));
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Basic $basicAuth',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // WooCommerce API 成功創建返回 201
        final Map<String, dynamic> data = json.decode(response.body);
        return RegisterResponse.fromJson(data);
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        return RegisterResponse(
          success: false,
          error: error['message'] ?? '註冊失敗',
        );
      }
    } catch (e) {
      return RegisterResponse(
        success: false,
        error: '網路錯誤: ${e.toString()}',
      );
    }
  }
}
