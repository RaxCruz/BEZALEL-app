import 'package:flutter/material.dart';
import '../api/models/user_device_info_response.dart';
import '../providers/locale_provider.dart';
import 'package:provider/provider.dart';

class DeviceDetailPage extends StatelessWidget {
  final DeviceInfo device;

  const DeviceDetailPage({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.watch<LocaleProvider>().isEnglish;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          device.deviceModel ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF4A89DC),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 設備圖標和狀態
            Column(
              children: [
                Image.asset(
                  'assets/images/device_icon.png',
                  height: 100,
                ),
                const SizedBox(height: 8),
                Text(
                  isEnglish ? 'Charger is in good status!' : '充電器狀態良好！',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 電池狀態
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.battery_charging_full, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    '42%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '45 ${isEnglish ? 'Minutes Remaining' : '分鐘剩餘'}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 充電速度
            _buildSection(
              title: isEnglish ? 'Charging Speed' : '充電速度',
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEnglish ? 'Input' : '輸入',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '5W',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isEnglish ? 'Wireless' : '無線',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '5W',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'USB-C',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '0W',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 200, // 调整高度
                    color: Colors.grey.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEnglish ? 'Output' : '輸出',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '10W',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isEnglish ? 'Wireless 1' : '無線 1',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '0W',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isEnglish ? 'Wireless 2' : '無線 2',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '5W',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'USB-C',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '10W',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 健康狀態和溫度
            Row(
              children: [
                Expanded(
                  child: _buildSection(
                    title: isEnglish ? 'Health' : '健康狀態',
                    child: const Text(
                      'Normal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSection(
                    title: isEnglish ? 'Temperature' : '溫度',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '25°C',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 20,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          print('Clicked section: $title');
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
