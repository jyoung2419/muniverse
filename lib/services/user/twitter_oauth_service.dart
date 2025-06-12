import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/dio_client.dart';

class TwitterOauthService {
  final Dio _dio = DioClient().dio;

  /// 1. 서버에서 request token 발급
  Future<String> getTwitterAuthUrl() async {
    final initRes = await _dio.get('/api/v1/user/app/oauth/twitter/init');
    final oauthToken = initRes.data['oauthToken'];

    final authUrl = Uri.https(
      'api.twitter.com',
      '/oauth/authorize',
      {'oauth_token': oauthToken},
    ).toString();

    return authUrl;
  }


  /// 2. 브라우저 열기
  Future<void> launchTwitterAuth() async {
    final authUrl = await getTwitterAuthUrl();
    if (!await launchUrl(Uri.parse(authUrl), mode: LaunchMode.externalApplication)) {
      throw Exception('트위터 인증 페이지 열기 실패');
    }
  }

  /// 3. 서버로 최종 인증 요청
  Future<Map<String, dynamic>> completeLogin(String oauthToken, String oauthVerifier) async {
    final response = await _dio.post(
      '${dotenv.env['BASE_URL']}:${dotenv.env['PORT']}/api/v1/user/app/oauth/twitter',
      data: {
        'oauthToken': oauthToken,
        'oauthVerifier': oauthVerifier,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    print('🔥 response.data: ${response.data}');
    return Map<String, dynamic>.from(response.data);
  }

  /// 추가정보 등록
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