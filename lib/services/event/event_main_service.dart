import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EventMainService {
  final Dio _dio;
  EventMainService(this._dio);

  Future<List<Map<String, dynamic>>> fetchMainEvents() async {
    try {
      final response = await _dio.get('/api/v1/event/main');
      final List<dynamic> raw = response.data['eventMainActive'];
      return raw.cast<Map<String, dynamic>>();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchEventMainVotes() async {
    try {
      final response = await _dio.get('/api/v1/event/main/vote');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchMainRelatedVideos() async {
    try {
      final response = await _dio.get('/api/v1/event/main/related');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ 관련 영상 API 실패: $e');
      rethrow;
    }
  }
}
