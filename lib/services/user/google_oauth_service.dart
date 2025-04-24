import 'package:dio/dio.dart';
import '../../utils/dio_client.dart';

class GoogleOauthService {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await _dio.post(
      '/api/v1/user/oauth/google',
      data: {'idToken': idToken},
    );

    // 🔥 Set-Cookie 로그 확인
    print("🔥 Set-Cookie: ${response.headers['set-cookie']}");

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
    if (phoneNumber != null) {
      data['phoneNumber'] = phoneNumber;
    }

    await _dio.post(
      '/api/v1/user/oauth/google/complete',
      data: data,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }
}
