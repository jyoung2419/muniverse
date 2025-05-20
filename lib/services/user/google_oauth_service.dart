import 'package:dio/dio.dart';
import '../../utils/dio_client.dart';
import '../../utils/shared_prefs_util.dart';

class GoogleOauthService {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await _dio.post(
      '/api/v1/user/app/oauth/google',
      data: {'idToken': idToken},
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final data = response.data;

    if (data['status'] == 'NEEDS_INFO' || data['status'] == 'NEW_USER') {
      return data;
    }

    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];

    if (accessToken == null || refreshToken == null) {
      throw Exception('❌ 토큰이 없습니다: $data');
    }

    await SharedPrefsUtil.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    print('✅ 로그인 시 저장된 accessToken: $accessToken');
    return data;
  }

  Future<void> completeGoogleUserInfo({
    required String userId,
    required String nickName,
    required String phoneNumber,
    required bool localFlag,
  }) async {
    final Map<String, dynamic> data = {
      'userId': userId,
      'nickName': nickName,
      'localFlag': localFlag,
    };
    if (phoneNumber.isNotEmpty) {
      data['phoneNumber'] = phoneNumber;
    }

    await _dio.post(
      '/api/v1/user/oauth/google/complete',
      data: data,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }
}
