import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoteService {
  final Dio _dio;

  VoteService() : _dio = Dio(BaseOptions(
    baseUrl: dotenv.env['PORT'] != null
        ? '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}'
        : dotenv.env['BASE_URL']!,
    headers: {'Content-Type': 'application/json'},
  ));

  // 투표 상세 조회
  Future<Map<String, dynamic>> getVoteDetail(String voteCode) async {
    try {
      final response = await _dio.get('/api/v1/vote/main/detail/$voteCode');
      return response.data;
    } catch (e) {
      print('❌ Vote Detail API 호출 실패: $e');
      rethrow;
    }
  }
}
