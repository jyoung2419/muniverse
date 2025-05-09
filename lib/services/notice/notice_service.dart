import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:muniverse_app/utils/shared_prefs_util.dart';

class NoticeService {
  final Dio _dio = Dio();

  NoticeService() {
    final baseUrl = dotenv.env['BASE_URL']!;
    final port = dotenv.env['PORT'];
    final fullUrl = port != null ? '$baseUrl:$port' : baseUrl;

    _dio.options.baseUrl = fullUrl;
  }

  Future<List<Map<String, dynamic>>> fetchNotices() async {
    try {
      final lang = await SharedPrefsUtil.getAcceptLanguage();
      final response = await _dio.get(
        '/api/v1/notice',
        options: Options(headers: {'Accept-Language': lang}),
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ Notice API 호출 실패: $e');
      rethrow;
    }
  }
}
