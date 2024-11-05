import 'package:flutter/foundation.dart';

class LocaleProvider extends ChangeNotifier {
  bool _isEnglish = false;

  bool get isEnglish => _isEnglish;

  void toggleLanguage() {
    _isEnglish = !_isEnglish;
    notifyListeners();
  }
}
