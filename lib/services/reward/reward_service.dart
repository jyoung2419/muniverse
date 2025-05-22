import 'package:dio/dio.dart';
import '../../models/reward/reward_page_response_model.dart';
import '../../models/reward/reward_user_info_model.dart';
import '../../utils/shared_prefs_util.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class RewardService {
  final Dio _dio;
  RewardService(this._dio);

  /// 당첨 리스트 조회
  Future<RewardPageResponse> fetchRewardList({int page = 0, int size = 10}) async {
    try {
      final token = await SharedPrefsUtil.getAccessToken();
      if (token == null) throw Exception('❌ accessToken 없음');

      final response = await _dio.get(
        '/api/v1/reward',
        queryParameters: {
          'page': page,
          'size': size,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      return RewardPageResponse.fromJson(response.data);
    } catch (e) {
      print('❌ Reward 리스트 API 호출 실패: $e');
      rethrow;
    }
  }

  /// 당첨 여부 조회
  Future<Map<String, dynamic>> fetchRewardCheck(String rewardCode) async {
    try {
      final token = await SharedPrefsUtil.getAccessToken();
      if (token == null) throw Exception('❌ accessToken 없음');

      final response = await _dio.get(
        '/api/v1/reward/check/$rewardCode',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print('❌ Reward 상세 API 호출 실패: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchRewardUserInfo(String rewardCode) async {
    try {
      final token = await SharedPrefsUtil.getAccessToken();
      if (token == null) throw Exception('❌ accessToken 없음');
      final response = await _dio.post(
        '/api/v1/reward/info/read',
        data: {'rewardCode': rewardCode},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      if (e is DioException) {
        print('❌ Dio error data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<void> submitRewardUserInfo(RewardUserInfoModel model) async {
    try {
      final token = await SharedPrefsUtil.getAccessToken();
      if (token == null) throw Exception('❌ accessToken 없음');

      final body = model.toJson();
      print('📤 제출 데이터: $body');

      final response = await _dio.post(
        '/api/v1/reward/info',
        data: body,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      print('✅ 제출 완료: ${response.data}');
    } catch (e) {
      print('❌ Reward 정보 제출 실패: $e');
      rethrow;
    }
  }
}
