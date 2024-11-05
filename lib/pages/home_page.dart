import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/side_navigation.dart';
import 'account_info_page.dart';
import 'device_page.dart';
import 'empty_device_page.dart';
import '../providers/locale_provider.dart';
import 'faq_page.dart';
import 'add_device_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _currentPage = const EmptyDevicePage();
  String _currentPageTitle = '添加設備';
  bool _isSidebarOpen = false;

  String _currentPageType = 'empty';

  final Duration _duration = const Duration(milliseconds: 300);

  void changePage(Widget page, String title) {
    setState(() {
      _currentPage = page;
      _currentPageTitle = title;
      if (page is EmptyDevicePage) {
        _currentPageType = 'empty';
      } else if (page is DevicePage) {
        _currentPageType = 'device';
      } else if (page is AccountInfoPage) {
        _currentPageType = 'account';
      } else if (page is FaqPage) {
        _currentPageType = 'faq';
      } else if (page is AddDevicePage) {
        _currentPageType = 'add_device';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.watch<LocaleProvider>().isEnglish;

    // 根據當前語言更新標題
    _updatePageTitle(isEnglish);

    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 主要內容區域（包含 AppBar）
          Column(
            children: [
              AppBar(
                backgroundColor: const Color(0xFF4A89DC),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isSidebarOpen = !_isSidebarOpen;
                    });
                  },
                ),
                title: Text(
                  _currentPageTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                centerTitle: true,
                actions: [
                  if (_currentPageType == 'device')
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        changePage(const AddDevicePage(),
                            isEnglish ? 'Add Device' : '添加設備');
                      },
                    ),
                ],
              ),
              Expanded(
                child: Container(
                  width: screenWidth,
                  color: Colors.grey[50],
                  child: _currentPage,
                ),
              ),
            ],
          ),
          // 遮罩層
          if (_isSidebarOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _isSidebarOpen = false),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          // 側邊欄
          AnimatedPositioned(
            duration: _duration,
            left: _isSidebarOpen ? 0 : -sidebarWidth,
            width: sidebarWidth,
            top: 0,
            bottom: 0,
            child: Material(
              color: Colors.black,
              child: SideNavigation(
                onPageChanged: (page, title) {
                  changePage(page, title);
                  setState(() => _isSidebarOpen = false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updatePageTitle(bool isEnglish) {
    // 根據當前頁面和語言設置對應的標題
    setState(() {
      _currentPageTitle = getPageTitle(_currentPage, isEnglish);
    });
  }

  String getPageTitle(Widget page, bool isEnglish) {
    switch (_currentPageType) {
      case 'empty':
        return isEnglish ? 'Add Device' : '添加設備';
      case 'device':
        return isEnglish ? 'Devices' : '設備';
      case 'account':
        return isEnglish ? 'Account Info' : '帳戶資訊';
      case 'faq':
        return isEnglish ? 'FAQ' : '客戶服務FAQ';
      case 'add_device':
        return isEnglish ? 'Add Device' : '添加設備';
      default:
        return _currentPageTitle;
    }
  }
}
