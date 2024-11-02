import 'package:flutter/material.dart';
import '../api/models/user_info_response.dart';

class UserProvider extends ChangeNotifier {
  UserInfoResponse? _userInfo;

  UserInfoResponse? get userInfo => _userInfo;

  void setUserInfo(UserInfoResponse userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }
} 