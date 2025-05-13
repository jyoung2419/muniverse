import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/google_translate_service.dart';
import '../utils/dio_client.dart';
import 'language_provider.dart';

class TranslationProvider with ChangeNotifier {
  final Map<String, String> _translations = {};
  final Map<String, String> _dynamicCache = {};
  String _currentLang = 'ko';

  String get currentLang => _currentLang;

  String get(String key) {
    return _translations[key] ?? key;
  }

  Future<void> loadTranslations(BuildContext context, List<String> keys) async {
    final langProvider = Provider.of<LanguageProvider>(navigatorKey.currentContext!, listen: false);
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

  Future<String> translate(String text) async {
    final langProvider = Provider.of<LanguageProvider>(navigatorKey.currentContext!, listen: false);
    final targetLang = langProvider.googleTargetLangCode;
    if (_currentLang != targetLang) {
      _currentLang = targetLang;
      _dynamicCache.clear();
    }
    final cacheKey = '$targetLang|$text';

    if (_dynamicCache.containsKey(cacheKey)) return _dynamicCache[cacheKey]!;

    try {
      final translator = GoogleTranslateService();
      final translated = await translator.translateText(text, targetLang: targetLang);
      _dynamicCache[cacheKey] = translated;

      return translated;
    } catch (_) {
      return text;
    }
  }

  void clear() {
    print('🧹 [TranslationProvider] 캐시 초기화');
    _translations.clear();
    _dynamicCache.clear();
    notifyListeners();
  }
}
