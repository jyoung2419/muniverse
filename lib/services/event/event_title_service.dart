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

  // Title 조회
  Future<Map<String, dynamic>> fetchEventTitle(String eventCode) async {
    try {
      final response = await _dio.get('/api/v1/event/title/$eventCode');
      return response.data;
    } catch (e) {
      print('❌ Title API 호출 실패: $e');
      rethrow;
    }
  }

  // Event 상세 설명 조회
  Future<String> fetchEventInfoContent(String eventCode) async {
    try {
      final response = await _dio.get('/api/v1/event/detail/info/$eventCode');
      return response.data['content'] as String;
    } catch (e) {
      print('❌ Event Info API 호출 실패: $e');
      rethrow;
    }
  }

  // VOD 리스트 조회
  Future<List<Map<String, dynamic>>> fetchEventVODList(String eventCode, int eventYear) async {
    final response = await _dio.get(
      '/api/v1/event/detail/vod/$eventCode',
      queryParameters: {
        'eventYear': eventYear,
      },
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  // Live 리스트 조회
  Future<List<Map<String, dynamic>>> fetchEventLiveList(String eventCode, int eventYear) async {
    try {
      final response = await _dio.get(
        '/api/v1/event/detail/live/$eventCode',
        queryParameters: {
          'eventYear': eventYear,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ Live 리스트 API 호출 실패: $e');
      rethrow;
    }
  }

  // Vote 리스트 조회
  Future<List<Map<String, dynamic>>> fetchEventVoteList(String eventCode, String status) async {
    try {
      final response = await _dio.get('/api/v1/event/detail/vote/$eventCode/$status');
      final List<dynamic> rawList = response.data;
      return rawList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ Vote 리스트 API 호출 실패: $e');
      rethrow;
    }
  }

  // 관련영상 리스트 조회
  Future<List<Map<String, dynamic>>> fetchEventRelatedVideos(String eventCode, {int? eventYear}) async {
    try {
      final response = await _dio.get(
        '/api/v1/event/detail/relate/$eventCode',
        queryParameters: eventYear != null ? {'eventYear': eventYear} : null,
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ Related Video API 호출 실패: $e');
      rethrow;
    }
  }
}
