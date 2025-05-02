import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/dio_client.dart';

class GoogleOauthService {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await Dio().post(
      '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}/api/v1/user/app/oauth/google',
      data: {'idToken': idToken},
      options: Options(
        headers: {'Content-Type': 'application/json'}, // Authorization 없이
      ),
    );

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
