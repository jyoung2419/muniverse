import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/google_translate_service.dart';
import 'language_provider.dart';

class TranslationProvider with ChangeNotifier {
  final Map<String, String> _translations = {};
  final Map<String, String> _dynamicCache = {};
  String _currentLang = 'ko';

  String get currentLang => _currentLang;

  /// 키워드 번역
  String get(String key) {
    return _translations[key] ?? key;
  }

  Future<void> loadTranslations(BuildContext context, List<String> keys) async {
    final langProvider = context.read<LanguageProvider>();
    final targetLang = langProvider.googleTargetLangCode;

    if (_currentLang == targetLang && _translations.isNotEmpty) return;

    _currentLang = targetLang;
    _translations.clear();
    _dynamicCache.clear();

    final translator = GoogleTranslateService();

    for (final key in keys) {
      try {
        final translated = await translator.translateText(key, targetLang: targetLang);
        _translations[key] = translated;
      } catch (e) {
        _translations[key] = key;
      }
    }

    notifyListeners();
  }

  /// 서버에서 온 동적 텍스트 번역
  Future<String> translate(String text) async {
    final cacheKey = '$_currentLang|$text';
    if (_dynamicCache.containsKey(cacheKey)) return _dynamicCache[cacheKey]!;

    try {
      final translator = GoogleTranslateService();
      final translated = await translator.translateText(text, targetLang: _currentLang);
      _dynamicCache[cacheKey] = translated;
      notifyListeners();
      return translated;
    } catch (_) {
      return text;
    }
  }

  void clear() {
    _translations.clear();
    _dynamicCache.clear();
    notifyListeners();
  }
}
