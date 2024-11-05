import 'package:flutter/material.dart';
import '../api/models/user_device_info_response.dart';

class DeviceProvider extends ChangeNotifier {
  UserDeviceInfoResponse? _deviceInfo;

  // 返回完整的设备列表
  List<DeviceInfo> get devices => _deviceInfo?.devices ?? [];

  // 如果需要检查是否有设备
  bool get hasDevices => devices.isNotEmpty;

  // 获取特定设备
  DeviceInfo? getDevice(int index) {
    if (index >= 0 && index < devices.length) {
      return devices[index];
    }
    return null;
  }

  void setDeviceInfo(UserDeviceInfoResponse deviceInfo) {
    _deviceInfo = deviceInfo;
    notifyListeners();
  }

  void clear() {
    _deviceInfo = null;
    notifyListeners();
  }

  // 可以添加更多设备相关的方法
  int get deviceCount => devices.length;

  // 根据设备ID获取设备
  DeviceInfo? getDeviceById(String id) {
    try {
      return devices.firstWhere((device) => device.deviceId == id);
    } catch (e) {
      return null;
    }
  }
}
