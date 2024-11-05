import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/device_provider.dart';
import '../providers/locale_provider.dart';
import '../pages/login_page.dart';
import '../pages/account_info_page.dart';
import '../pages/device_page.dart';
import '../pages/faq_page.dart';

class SideNavigation extends StatefulWidget {
  final Function(Widget, String) onPageChanged;

  const SideNavigation({
    super.key,
    required this.onPageChanged,
  });

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    // 初始化時觸發設備頁面
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onPageChanged(const DevicePage(), '設備');
    });
  }

  Future<void> _showLogoutDialog() async {
    final isEnglish = context.read<LocaleProvider>().isEnglish;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEnglish ? 'Confirm Logout' : '確認登出'),
          content:
              Text(isEnglish ? 'Are you sure you want to logout?' : '確定要登出嗎？'),
          actions: <Widget>[
            TextButton(
              child: Text(
                isEnglish ? 'Cancel' : '取消',
                style: const TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                isEnglish ? 'Confirm' : '確定',
                style: const TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                _handleLogout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() async {
    try {
      // 清除用戶數據
      await context.read<UserProvider>().logout();

      // 清除設備數據
      context.read<DeviceProvider>().clear();

      // 導航到登入頁面
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      print('登出錯誤: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.watch<LocaleProvider>().isEnglish;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildNavItem(
                    icon: Icons.person_outline,
                    label: isEnglish ? 'Account Info' : '帳戶資訊',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.devices_outlined,
                    label: isEnglish ? 'Devices' : '設備',
                    index: 1,
                  ),
                  const SizedBox(height: 16),
                  _buildNavItem(
                    icon: Icons.help_outline,
                    label: isEnglish ? 'FAQ' : '客戶服務FAQ',
                    index: 3,
                  ),
                  _buildNavItem(
                    icon: Icons.language,
                    label: isEnglish ? 'English' : '中文',
                    index: 4,
                  ),
                  const Divider(
                    height: 32,
                    thickness: 0.5,
                    color: Colors.black12,
                    indent: 16,
                    endIndent: 16,
                  ),
                  _buildNavItem(
                    icon: Icons.logout,
                    label: isEnglish ? 'Logout' : '登出',
                    index: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    if (index == 4) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black87,
            size: 22,
          ),
          title: Row(
            children: [
              Text(
                context.watch<LocaleProvider>().isEnglish ? 'English' : '中文',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: context.watch<LocaleProvider>().isEnglish,
                  onChanged: (value) {
                    context.read<LocaleProvider>().toggleLanguage();
                    setState(() {});
                  },
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.blue.withOpacity(0.2),
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[300],
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          horizontalTitleGap: 8,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.black87,
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black87,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
        horizontalTitleGap: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          if (index == 5) {
            // 登出選項
            _showLogoutDialog();
          } else {
            setState(() {
              _selectedIndex = index;
            });

            // 根據索引返回對應的頁面
            Widget page;
            String pageTitle = label;

            switch (index) {
              case 0:
                page = const AccountInfoPage();
                break;
              case 1:
                page = const DevicePage();
                break;
              case 3: // FAQ
                page = const FaqPage();
                break;
              default:
                page = Container();
            }

            widget.onPageChanged(page, pageTitle);
          }
        },
      ),
    );
  }
}
