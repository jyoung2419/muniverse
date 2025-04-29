import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late final Dio dio;
  PersistCookieJar? _cookieJar;

  DioClient._internal();

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _cookieJar = PersistCookieJar(
      storage: FileStorage("${dir.path}/.cookies/"),
    );

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

    dio.interceptors.add(CookieManager(_cookieJar!));
    dio.interceptors.add(LogInterceptor(responseHeader: true));
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401 &&
            !error.requestOptions.path.contains('/jwt/refresh')) {
          try {
            final refreshResponse = await dio.post('/api/v1/jwt/refresh');
            if (refreshResponse.statusCode == 200) {
              final retryOptions = error.requestOptions;
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
          } catch (e) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
            return handler.reject(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<void> loadCookies() async {
    final dir = await getApplicationDocumentsDirectory();
    _cookieJar ??= PersistCookieJar(storage: FileStorage("${dir.path}/.cookies/"));
    dio.interceptors.add(CookieManager(_cookieJar!));
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // 전역적으로 접근 가능