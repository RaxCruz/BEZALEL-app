import 'package:flutter/material.dart';
import '../api/models/user_device_info_response.dart';

class DeviceProvider extends ChangeNotifier {
  UserDeviceInfoResponse? _deviceInfo;
  DeviceInfo? get deviceInfo => _deviceInfo?.devices?.firstOrNull;

  void setDeviceInfo(UserDeviceInfoResponse deviceInfo) {
    _deviceInfo = deviceInfo;
    notifyListeners();
  }
} 