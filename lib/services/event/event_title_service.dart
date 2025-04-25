import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EventTitleService {
  final Dio _dio = Dio();

  EventTitleService() {
    final baseUrl = dotenv.env['BASE_URL']!;
    final port = dotenv.env['PORT'];
    final fullUrl = port != null ? '$baseUrl:$port' : baseUrl;

    _dio.options.baseUrl = fullUrl;
  }

  Future<Map<String, dynamic>> fetchEventTitle(String eventCode) async {
    try {
      final response = await _dio.get('/api/v1/event/title/$eventCode');
      print('📦 Title Response for $eventCode: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ Title API 호출 실패: $e');
      rethrow;
    }
  }
}
