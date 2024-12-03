import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class EmptyDevicePage extends StatelessWidget {
  const EmptyDevicePage({super.key});

  String _getAddDeviceText(BuildContext context) {
    final isEnglish = context.watch<LocaleProvider>().isEnglish;
    return isEnglish ? 'Add Your First Device' : '添加您的第一台設備';
  }

  String _getHelpText(BuildContext context) {
    final isEnglish = context.watch<LocaleProvider>().isEnglish;
    return isEnglish ? 'This app helps you to:' : '該應用程式可以幫助您:';
  }

  String _getFeatureText(BuildContext context, int index) {
    final isEnglish = context.watch<LocaleProvider>().isEnglish;
    switch (index) {
      case 0:
        return isEnglish ? 'Check your device status' : '查看您的設備狀態';
      case 1:
        return isEnglish ? 'Manage your devices' : '管理您的設備';
      case 2:
        return isEnglish ? 'Monitor device services' : '監視裝置服務';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圓形添加按鈕
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),

          // 提示文字
          Text(
            _getAddDeviceText(context),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // 功能說明列表
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getHelpText(context),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                _buildFeatureItem(context, 0),
                _buildFeatureItem(context, 1),
                _buildFeatureItem(context, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Text('• ', style: TextStyle(color: Colors.grey)),
          Text(
            _getFeatureText(context, index),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
