import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/shared_prefs_util.dart';
import 'package:flutter/material.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio dio;

  DioClient._internal();

  Future<void> init() async {
    final base = dotenv.env['BASE_URL'] ?? 'http://localhost';
    final port = dotenv.env['PORT'] ?? '8080';
    final fullBaseUrl = "$base:$port";

    dio = Dio(BaseOptions(
      baseUrl: fullBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    dio.interceptors.clear();

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final deviceId = await SharedPrefsUtil.getOrCreateDeviceId();
        final userAgent = Platform.isAndroid ? 'MuniverseApp/Android' : 'MuniverseApp/iOS';
        final rawLang = await SharedPrefsUtil.getAcceptLanguage();
        final langCode = rawLang == 'kr' ? 'kr' : 'en';
        options.headers['Accept-Language'] = langCode;
        options.headers['X-Device-Id'] = deviceId;
        options.headers['User-Agent'] = userAgent;

        if (options.path.contains('/api/v1/jwt/refresh')) {
          final refreshToken = await SharedPrefsUtil.getRefreshToken();
          if (refreshToken != null) {
            options.headers['Authorization'] = 'Bearer $refreshToken';
          }
          print('🚀 refresh 요청 Authorization: ${options.headers['Authorization']}');
        } else {
          final accessToken = await SharedPrefsUtil.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          print('🚀 일반 요청 Authorization: ${options.headers['Authorization']}');
        }

        return handler.next(options);
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if ((error.response?.statusCode == 401 || error.response?.statusCode == 403) &&
            !error.requestOptions.path.contains('api/v1/jwt/refresh')) {
          try {
            final refreshResponse = await dio.post('/api/v1/jwt/refresh');

            if (refreshResponse.statusCode == 200) {
              final newAccessToken = refreshResponse.data['accessToken'];
              final newRefreshToken = refreshResponse.data['refreshToken'];

              await SharedPrefsUtil.saveTokens(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken ?? await SharedPrefsUtil.getRefreshToken(),
              );

              final retryOptions = error.requestOptions;
              retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

              return handler.resolve(await dio.fetch(retryOptions));
            }
          } catch (_) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
            return handler.reject(error);
          }
        }

        return handler.next(error);
      },
    ));

    dio.interceptors.add(LogInterceptor(responseHeader: true));
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final dioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});