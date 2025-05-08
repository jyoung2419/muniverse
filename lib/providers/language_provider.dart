import 'package:flutter/material.dart';

import '../utils/shared_prefs_util.dart';

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = '한국어';
  String get selectedLanguage => _selectedLanguage;
  String get selectedLanguageCode {
    switch (_selectedLanguage) {
      case '한국어': return 'kr';
      case 'English': return 'en';
      case '日本語': return 'jp';
      case '简体中文': return 'cn';
      case '繁體中文': return 'tw';
      default: return 'kr';
    }
  }

  String get languageText => _selectedLanguage;

  Future<void> init() async {
    final langCode = await SharedPrefsUtil.getAcceptLanguage();
    switch (langCode) {
      case 'kr': _selectedLanguage = '한국어'; break;
      case 'en': _selectedLanguage = 'English'; break;
      case 'jp': _selectedLanguage = '日本語'; break;
      case 'cn': _selectedLanguage = '简体中文'; break;
      case 'tw': _selectedLanguage = '繁體中文'; break;
      default: _selectedLanguage = '한국어';
    }
    notifyListeners();
  }

  void setLanguage(String langCode) {
    switch (langCode) {
      case 'kr': _selectedLanguage = '한국어'; break;
      case 'en': _selectedLanguage = 'English'; break;
      case 'jp': _selectedLanguage = '日本語'; break;
      case 'cn': _selectedLanguage = '简体中文'; break;
      case 'tw': _selectedLanguage = '繁體中文'; break;
      default: _selectedLanguage = '한국어';
    }
    notifyListeners();
  }
}
