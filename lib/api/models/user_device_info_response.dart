class UserDeviceInfoResponse {
  final List<DeviceInfo>? devices;
  final bool? success;
  final String? error;

  UserDeviceInfoResponse({
    this.devices,
    this.success,
    this.error,
  });

  factory UserDeviceInfoResponse.fromJson(Map<String, dynamic> json) {
    return UserDeviceInfoResponse(
      devices: (json['devices'] as List<dynamic>?)
          ?.map((device) => DeviceInfo.fromJson(device))
          .toList(),
      success: json['success'],
      error: json['error'],
    );
  }

  factory UserDeviceInfoResponse.fromJsonList(List<dynamic> jsonList) {
    try {
      return UserDeviceInfoResponse(
        devices: jsonList.map((json) => DeviceInfo.fromJson(json)).toList(),
        success: true,
        error: null,
      );
    } catch (e) {
      return UserDeviceInfoResponse(
        devices: [],
        success: false,
        error: '解析設備資訊失敗: ${e.toString()}',
      );
    }
  }
}

class DeviceInfo {
  final String? deviceId;
  final String? deviceName;
  final String? deviceModel;
  final String? deviceType;
  final String? pairedTime;
  final String? lastConnected;
  final String? status;

  DeviceInfo({
    this.deviceId,
    this.deviceName,
    this.deviceModel,
    this.deviceType,
    this.pairedTime,
    this.lastConnected,
    this.status,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      deviceId: json['device_id'],
      deviceName: json['device_name'],
      deviceModel: json['device_model'],
      deviceType: json['device_type'],
      pairedTime: json['paired_time'],
      lastConnected: json['last_connected'],
      status: json['status'],
    );
  }
} 