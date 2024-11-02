import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/device_provider.dart';

class DeviceListPage extends StatelessWidget {
  const DeviceListPage({super.key});

  String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return '-';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (context, provider, child) {
        final deviceInfo = provider.deviceInfo;
        
        if (deviceInfo == null) {
          return const Center(
            child: Text(
              '無設備資料',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInfoCard(
              '設備資訊',
              [
                _buildInfoRow('設備 ID', deviceInfo.deviceId ?? '-'),
                _buildInfoRow('設備名稱', deviceInfo.deviceName ?? '-'),
                _buildInfoRow('設備型號', deviceInfo.deviceModel ?? '-'),
                _buildInfoRow('設備類型', deviceInfo.deviceType ?? '-'),
                _buildInfoRow('配對時間', formatDateTime(deviceInfo.pairedTime)),
                _buildInfoRow('最後連接', formatDateTime(deviceInfo.lastConnected)),
                _buildInfoRow('狀態', deviceInfo.status ?? '-'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      color: const Color(0xFF2D333B),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.devices,
                  color: Color(0xFF539BF5),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF539BF5),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFF444C56)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF768390),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 