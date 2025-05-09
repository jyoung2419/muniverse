import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        final accessToken = await SharedPrefsUtil.getAccessToken();
        print('🔥 accessToken: $accessToken');
        final deviceId = await SharedPrefsUtil.getOrCreateDeviceId();
        final userAgent = Platform.isAndroid
            ? 'MuniverseApp/Android'
            : 'MuniverseApp/iOS';
        final lang = await SharedPrefsUtil.getAcceptLanguage();
        options.headers['Accept-Language'] = lang;
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        options.headers['X-Device-Id'] = deviceId;
        options.headers['User-Agent'] = userAgent;

        print('🚀 최종 Authorization: ${options.headers['Authorization']}');

        return handler.next(options);
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if ((error.response?.statusCode == 401 || error.response?.statusCode == 403) &&
            !error.requestOptions.path.contains('/jwt/refresh')) {
          try {
            final refreshToken = await SharedPrefsUtil.getRefreshToken();
            final deviceId = await SharedPrefsUtil.getOrCreateDeviceId();
            final userAgent = Platform.isAndroid
                ? 'MuniverseApp/Android'
                : 'MuniverseApp/iOS';

            final refreshResponse = await dio.post(
              '/api/v1/jwt/refresh',
              options: Options(headers: {
                'Authorization': 'Bearer $refreshToken',
                'User-Agent': userAgent,
                'X-Device-Id': deviceId,
              }),
            );

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