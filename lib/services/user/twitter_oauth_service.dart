import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/dio_client.dart';

class TwitterOauthService {
  final Dio _dio = DioClient().dio;

  Future<String> initiateTwitterLogin() async {
    final response = await _dio.get(
      '/api/v1/user/app/oauth/twitter/init',
    );
    return response.data['redirectUrl'];
  }

  Future<Map<String, dynamic>> loginWithTwitter({
    required String oauthToken,
    required String oauthVerifier,
  }) async {
    final response = await _dio.post(
      '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}/api/v1/user/app/oauth/twitter',
      data: {
        'oauthToken': oauthToken,
        'oauthVerifier': oauthVerifier,
      },
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    return response.data;
  }

  Future<void> completeTwitterUserInfo({
    required String userId,
    required String nickName,
    required String email,
    required bool isLocalFlag,
  }) async {
    await _dio.post(
      '/api/v1/user/app/oauth/twitter/complete',
      data: {
        'userId': userId,
        'nickName': nickName,
        'email': email,
        'localFlag': isLocalFlag,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }
}
