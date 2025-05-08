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

    // 공통 헤더 인터셉터
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await SharedPrefsUtil.getAccessToken();
        print('🔥 accessToken: $accessToken');
        final deviceId = await SharedPrefsUtil.getOrCreateDeviceId();
        final userAgent = Platform.isAndroid
            ? 'MuniverseApp/Android'
            : 'MuniverseApp/iOS';
        print('🔥 DioClient onRequest - accessToken: $accessToken');

        // 언어 동적 설정
        final lang = await SharedPrefsUtil.getAcceptLanguage();
        options.headers['Accept-Language'] = lang;

        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        options.headers['X-Device-Id'] = deviceId;
        options.headers['User-Agent'] = userAgent;

        return handler.next(options);
      },
    ));

    // 토큰 만료 시 자동 재발급 및 재요청
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401 &&
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

              final clonedRequest = await dio.request(
                retryOptions.path,
                options: Options(
                  method: retryOptions.method,
                  headers: retryOptions.headers,
                ),
                data: retryOptions.data,
                queryParameters: retryOptions.queryParameters,
              );

              return handler.resolve(clonedRequest);
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