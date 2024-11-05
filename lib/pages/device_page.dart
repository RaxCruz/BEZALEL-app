import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_provider.dart';
import './empty_device_page.dart';
import '../providers/locale_provider.dart';
import './device_detail_page.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    String _getStatusText(String? status) {
      final isEnglish = context.watch<LocaleProvider>().isEnglish;

      switch (status) {
        case 'ready':
          return isEnglish ? 'Ready to Use' : '可使用';
        case 'error':
          return isEnglish ? 'Connection error' : '連線錯誤';
        case 'offline':
          return isEnglish ? 'Offline' : '離線';
        default:
          return isEnglish ? 'Unknown' : '未知';
      }
    }

    return Scaffold(
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          final devices = deviceProvider.devices;
          return devices.isEmpty
              ? const EmptyDevicePage()
              : ListView.builder(
                  itemCount: devices.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Material(
                          color: Colors.white,
                          elevation: 1,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DeviceDetailPage(device: device),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 96,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 48,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/device_icon.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 4),
                                          child: Text(
                                            device.deviceModel ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              margin: const EdgeInsets.only(
                                                  right: 8),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _getStatusColor(
                                                    device.status),
                                              ),
                                            ),
                                            Text(_getStatusText(device.status)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'ready':
        return Colors.green;
      case 'error':
        return Colors.red;
      case 'offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
