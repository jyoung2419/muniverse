import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SharedPrefsUtil {
  static const _deviceIdKey = 'x-device-id';
  static const _userStatusKey = 'userStatus';
  static const _languageKey = 'accept-language';

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

  // 언어
  static Future<void> saveAcceptLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang);
  }

  static Future<String> getAcceptLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'KR'; // 기본값 KR
  }

}