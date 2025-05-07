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
        headers: {'Content-Type': 'application/json'}, // Authorization 없이
      ),
    );

    // ✅ accessToken 저장 + print 추가
    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];
    await SharedPrefsUtil.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    print('✅ 로그인 시 저장된 accessToken: $accessToken');

    return response.data;
  }

  Future<void> completeGoogleUserInfo({
    required String userId,
    required String nickName,
    required String phoneNumber,
  }) async {
    final Map<String, dynamic> data = {
      'userId': userId,
      'nickName': nickName,
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
