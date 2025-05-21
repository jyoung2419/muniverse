import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SharedPrefsUtil {
  static const _deviceIdKey = 'x-device-id';
  static const _userStatusKey = 'userStatus';
  static const _acceptLanguageKey = 'acceptLanguage';
  static const _popupHiddenUntilKey = 'popup_hidden_until';

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) throw Exception("❌ userId가 없습니다.");
    return userId;
  }

  static Future<void> saveUserStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userStatusKey, status);
  }

  static Future<String?> getUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userStatusKey);
  }

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static Future<String> getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await prefs.setString(_deviceIdKey, deviceId);
    }
    return deviceId;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString(_deviceIdKey);
    await prefs.clear();
    if (deviceId != null) {
      await prefs.setString(_deviceIdKey, deviceId);
    }
  }

  // 팝업
  static Future<void> setPopupHiddenUntilTomorrow() async {
    final prefs = await SharedPreferences.getInstance();
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final normalized = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    await prefs.setString(_popupHiddenUntilKey, normalized.toIso8601String());
  }

  static Future<bool> isPopupHiddenToday() async {
    final prefs = await SharedPreferences.getInstance();
    final untilStr = prefs.getString(_popupHiddenUntilKey);
    if (untilStr == null) return false;

    final hiddenUntil = DateTime.tryParse(untilStr);
    if (hiddenUntil == null) return false;

    return hiddenUntil.isAfter(DateTime.now());
  }

  // 팝업별로 '오늘 하루 숨기기' 설정 저장
  static Future<void> setPopupHiddenUntilTomorrowWithKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final normalized = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    await prefs.setString('popup_hidden_until_$key', normalized.toIso8601String());
  }

  // 팝업별로 숨김 여부 확인
  static Future<bool> isPopupHiddenTodayWithKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final untilStr = prefs.getString('popup_hidden_until_$key');
    if (untilStr == null) return false;

    final hiddenUntil = DateTime.tryParse(untilStr);
    if (hiddenUntil == null) return false;

    return hiddenUntil.isAfter(DateTime.now());
  }

  // 언어
  static Future<void> setAcceptLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_acceptLanguageKey, lang);
  }

  static Future<String> getAcceptLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_acceptLanguageKey) ?? 'kr';
  }
}