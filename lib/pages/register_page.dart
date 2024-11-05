import 'package:flutter/material.dart';
import '../api/services/wordpress_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final WordPressService _wordPressService = WordPressService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;

  // 錯誤訊息
  String? _emailError;
  String? _firstNameError;
  String? _lastNameError;
  String? _usernameError;
  String? _passwordError;

  // 驗證表單
  bool _validateForm() {
    bool isValid = true;

    setState(() {
      _emailError = null;
      _firstNameError = null;
      _lastNameError = null;
      _usernameError = null;
      _passwordError = null;

      if (_emailController.text.trim().isEmpty) {
        _emailError = '請輸入電子郵件';
        isValid = false;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(_emailController.text)) {
        _emailError = '請輸入有效的電子郵件';
        isValid = false;
      }

      if (_lastNameController.text.trim().isEmpty) {
        _lastNameError = '請輸入姓氏';
        isValid = false;
      }

      if (_firstNameController.text.trim().isEmpty) {
        _firstNameError = '請輸入名字';
        isValid = false;
      }

      if (_usernameController.text.trim().isEmpty) {
        _usernameError = '請輸入使用者名稱';
        isValid = false;
      }

      if (_passwordController.text.trim().isEmpty) {
        _passwordError = '請輸入密碼';
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        _passwordError = '密碼長度至少需要6個字元';
        isValid = false;
      }
    });

    return isValid;
  }

  // 處理註冊
  Future<void> _handleRegister() async {
    if (_isLoading) return;

    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _wordPressService.register(
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (response.success) {
        // 註冊成功，返回登入頁
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('註冊成功！請登入'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _passwordError = response.error;
        });
      }
    } catch (e) {
      setState(() {
        _passwordError = '註冊失敗: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                  width: 80,
                ),
              ),
              const SizedBox(height: 20),

              // 標題
              const Center(
                child: Text(
                  "創建帳號",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 表單欄位
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '電子郵件',
                  hintText: 'example@email.com',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _emailError,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: '姓氏',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _lastNameError,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: '名字',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _firstNameError,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '使用者名稱',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _usernameError,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: '密碼',
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
              ),
              const SizedBox(height: 24),

              // 註冊按鈕
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
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
                          '註冊',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // 返回登入
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "已經有帳號了? ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "登入",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
