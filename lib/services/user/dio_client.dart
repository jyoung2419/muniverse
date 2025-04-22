import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late final Dio dio;

  DioClient._internal();

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(
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

    dio.interceptors.add(CookieManager(cookieJar));
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
            return handler.reject(error);
          }
        }
        return handler.next(error);
      },
    ));
  }
}