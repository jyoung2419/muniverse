import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EventMainService {
  final Dio _dio = Dio();

  EventMainService() {
    final baseUrl = dotenv.env['BASE_URL']!;
    final port = dotenv.env['PORT'];
    final fullUrl = port != null ? '$baseUrl:$port' : baseUrl;

    _dio.options.baseUrl = fullUrl;
  }

  Future<List<Map<String, dynamic>>> fetchMainEvents() async {
    try {
      final response = await _dio.get('/api/v1/event/main');
      print('📦 Response: ${response.data}');
      final List<dynamic> raw = response.data['eventMainActive'];
      return raw.cast<Map<String, dynamic>>();
    } catch (e) {
      rethrow;
    }
  }
}
