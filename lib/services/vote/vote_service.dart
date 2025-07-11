import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/shared_prefs_util.dart';

class VoteService {
  final Dio _dio;
  VoteService(this._dio);
  // 상태별 투표 목록 조회
  Future<List<Map<String, dynamic>>> getVotesByStatus(String status) async {
    try {
      final lang = await SharedPrefsUtil.getAcceptLanguage();
      final response = await _dio.get(
        '/api/v1/vote/main/$status',
        options: Options(headers: {
          'Accept-Language': lang,
        }),
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ Vote List API 호출 실패: $e');
      rethrow;
    }
  }

  // 투표 상세 조회
  Future<Map<String, dynamic>> getVoteDetail(String voteCode) async {
    try {
      final lang = await SharedPrefsUtil.getAcceptLanguage();
      final response = await _dio.get(
        '/api/v1/vote/main/detail/$voteCode',
        options: Options(headers: {
          'Accept-Language': lang,
        }),
      );
      return response.data;
    } catch (e) {
      print('❌ Vote Detail API 호출 실패: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getVoteRewardMedia(String voteCode) async {
    try {
      final lang = await SharedPrefsUtil.getAcceptLanguage();
      final response = await _dio.get(
        '/api/v1/vote/main/media/$voteCode',
        options: Options(headers: {
          'Accept-Language': lang,
        }),
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ Vote Reward Media API 호출 실패: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getVoteAvailability(String voteCode) async {
    try {
      final token = await SharedPrefsUtil.getAccessToken();
      if (token == null) throw Exception('❌ accessToken 없음');

      final response = await _dio.get(
        '/api/v1/vote/main/detail/freeCount/$voteCode',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

      return response.data;
    } catch (e) {
      print('❌ Vote Availability API 호출 실패: $e');
      rethrow;
    }
  }
}
