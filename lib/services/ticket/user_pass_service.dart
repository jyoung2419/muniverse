import 'package:dio/dio.dart';
import '../../models/ticket/user_pass_model.dart';
import '../../utils/shared_prefs_util.dart';

class UserPassService {
  final Dio _dio;
  UserPassService(this._dio);

  Future<List<UserPassModel>> fetchMyUserPasses() async {
    try {
      final token = await SharedPrefsUtil.getAccessToken();
      if (token == null) throw Exception('❌ accessToken 없음');

      final response = await _dio.get(
        '/api/v1/ticket/pass/user/me',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final List<dynamic> data = response.data;
      return data.map((e) => UserPassModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ 이용권 조회 실패: $e');
      rethrow;
    }
  }

  Future<void> registerUserPass(String pinNumber) async {
    try {
      final token = await SharedPrefsUtil.getAccessToken();
      if (token == null) throw Exception('❌ accessToken 없음');

      await _dio.post(
        '/api/v1/ticket/pass',
        data: {'pinNumber': pinNumber},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } catch (e) {
      print('❌ 이용권 등록 실패: $e');
      rethrow;
    }
  }
}
