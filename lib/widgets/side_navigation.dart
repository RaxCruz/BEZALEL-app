import 'package:flutter/material.dart';
import '../pages/device_list_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/analytics_page.dart';
import '../pages/settings_page.dart';

class SideNavigation extends StatefulWidget {
  final Function(Widget) onPageChanged;
  
  const SideNavigation({
    super.key,
    required this.onPageChanged,
  });

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 250 : 70,
      child: Container(
        color: const Color(0xFF1F2328),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // 收合按鈕
            Align(
              alignment: isExpanded ? Alignment.centerRight : Alignment.center,
              child: IconButton(
                icon: Icon(
                  isExpanded ? Icons.chevron_left : Icons.chevron_right,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // 用戶資訊
            if (isExpanded) ...[
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('https://placeholder.com/150'),
              ),
              const SizedBox(height: 10),
              const Text(
                '使用者名稱',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://placeholder.com/150'),
              ),
              const SizedBox(height: 20),
            ],
            // 導航項目
            _buildNavItem(
              icon: Icons.dashboard_rounded,
              label: '儀表板',
              onTap: () {
                widget.onPageChanged(const DashboardPage());
              },
            ),
            _buildNavItem(
              icon: Icons.analytics_rounded,
              label: '數據分析',
              onTap: () {
                widget.onPageChanged(const AnalyticsPage());
              },
            ),
            _buildNavItem(
              icon: Icons.settings_rounded,
              label: '系統設定',
              onTap: () {
                widget.onPageChanged(const SettingsPage());
              },
            ),
            _buildNavItem(
              icon: Icons.devices_rounded,
              label: '設備管理',
              onTap: () {
                widget.onPageChanged(const DeviceListPage());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isExpanded ? 16 : 0,
        vertical: 12,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isExpanded ? 12 : 0,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: isExpanded 
                  ? MainAxisAlignment.start 
                  : MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
} 