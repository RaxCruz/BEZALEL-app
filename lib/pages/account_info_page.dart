import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/locale_provider.dart';

class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({super.key});

  Map<String, String> _getText(bool isEnglish) {
    return {
      'accountInfo': isEnglish ? 'Account Info' : '帳戶資訊',
      'username': isEnglish ? 'Username' : '用戶名稱',
      'email': isEnglish ? 'Email' : '電子信箱',
      'userId': isEnglish ? 'User ID' : '用戶ID',
      'userRole': isEnglish ? 'User Role' : '用戶角色',
    };
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = context.watch<UserProvider>().userInfo;
    final isEnglish = context.watch<LocaleProvider>().isEnglish;
    final texts = _getText(isEnglish);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texts['accountInfo']!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoItem(
            icon: Icons.person_outline,
            label: texts['username']!,
            value: userInfo?.name ?? '-',
          ),
          _buildInfoItem(
            icon: Icons.email_outlined,
            label: texts['email']!,
            value: userInfo?.email ?? '-',
          ),
          _buildInfoItem(
            icon: Icons.badge_outlined,
            label: texts['userId']!,
            value: userInfo?.id?.toString() ?? '-',
          ),
          _buildInfoItem(
            icon: Icons.admin_panel_settings_outlined,
            label: texts['userRole']!,
            value: userInfo?.roles ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
