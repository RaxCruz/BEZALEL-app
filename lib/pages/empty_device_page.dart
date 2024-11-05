import 'package:flutter/material.dart';

class EmptyDevicePage extends StatelessWidget {
  const EmptyDevicePage({super.key});

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
            '添加您的第一台設備',
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
                  '該應用程式可以幫助您:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                _buildFeatureItem('查看您的設備狀態'),
                _buildFeatureItem('管理您的設備'),
                _buildFeatureItem('監視裝置服務'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Text('• ', style: TextStyle(color: Colors.grey)),
          Text(
            text,
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
