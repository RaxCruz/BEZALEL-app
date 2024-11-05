import 'package:flutter/material.dart';
import '../api/models/user_info_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  UserInfoResponse? _userInfo;

  UserInfoResponse? get userInfo => _userInfo;

  void setUserInfo(UserInfoResponse userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }

  void clear() {
    _userInfo = null;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      // 清除用戶數據
      _userInfo = null;

      // 清除本地存儲
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userInfo');

      notifyListeners();
    } catch (e) {
      print('登出錯誤: $e');
      rethrow;
    }
  }
}
