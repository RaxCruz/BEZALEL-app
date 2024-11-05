import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device_provider.dart';
import 'home_page.dart';
import '../providers/user_provider.dart';
import '../api/services/wordpress_service.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final WordPressService _wordPressService = WordPressService();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // 添加錯誤訊息狀態
  String? _accountError;
  String? _passwordError;

  // 添加密碼顯示狀態
  bool _showPassword = false;

  // 驗證表單並處理登入
  Future<bool> _validateAndLogin() async {
    bool isValid = true;

    setState(() {
      // 清除之前的錯誤訊息
      _accountError = null;
      _passwordError = null;

      // 檢查是否為空
      if (_accountController.text.trim().isEmpty) {
        _accountError = '請輸入帳號';
        isValid = false;
      }
      if (_passwordController.text.trim().isEmpty) {
        _passwordError = '請輸入密碼';
        isValid = false;
      }
    });

    if (!isValid) return false;

    try {
      final loginResponse = await _wordPressService.login(
        _accountController.text,
        _passwordController.text,
      );

      if (!loginResponse.success) {
        setState(() {
          // 根據錯誤類型設置相應的錯誤訊息
          if (loginResponse.error?.contains('帳號') ?? false) {
            _accountError = loginResponse.error;
          } else if (loginResponse.error?.contains('密碼') ?? false) {
            _passwordError = loginResponse.error;
          } else {
            _passwordError = loginResponse.error ?? '登入失敗';
          }
        });
        return false;
      }

      return true;
    } catch (e) {
      setState(() {
        _passwordError = '發生錯誤: $e';
      });
      return false;
    }
  }

  void _handleLogin(BuildContext context) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final loginSuccess = await _validateAndLogin();

      if (loginSuccess) {
        final loginResponse = await _wordPressService.login(
          _accountController.text,
          _passwordController.text,
        );

        final userInfoResponse =
            await _wordPressService.getUserInfo(loginResponse.token!);
        final userInfoDeviceResponse =
            await _wordPressService.getUserDeviceInfo(loginResponse.token!);

        if (userInfoResponse.success) {
          if (!mounted) return;
          context.read<UserProvider>().setUserInfo(userInfoResponse);
          context.read<DeviceProvider>().setDeviceInfo(userInfoDeviceResponse);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          setState(() {
            _passwordError = userInfoResponse.error ?? '獲取用戶信息失敗';
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 在輸入框的 onChanged 中清除錯誤訊息
  void _clearAccountError(String _) {
    if (_accountError != null) {
      setState(() {
        _accountError = null;
      });
    }
  }

  void _clearPasswordError(String _) {
    if (_passwordError != null) {
      setState(() {
        _passwordError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),

              // 標題
              const Center(
                child: Text(
                  "登入帳號",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 副標題
              Center(
                child: Text(
                  "已有Bezalel帳號請直接登入",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "沒有帳號? ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "創建帳號",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 帳號輸入框
              TextField(
                controller: _accountController,
                decoration: InputDecoration(
                  hintText: '帳號',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _accountError,
                ),
                onChanged: _clearAccountError,
              ),
              const SizedBox(height: 16),

              // 密碼輸入框
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  hintText: '密碼',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                onChanged: _clearPasswordError,
              ),
              const SizedBox(height: 16),

              // 記住我選項
              Row(
                children: [
                  Checkbox(
                    value: false, // 添加狀態管理
                    onChanged: (value) {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Text("我同意Bezalel的"),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "隱私政策",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 登入按鈕
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A9BE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          '登入',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // 社群登入按鈕
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/google.png', // 請確保添加圖片
                      height: 24,
                    ),
                    label: const Text('Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/facebook.png', // 請確保添加圖片
                      height: 24,
                    ),
                    label: const Text('Facebook'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialLoginButton(String label, IconData icon) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}
