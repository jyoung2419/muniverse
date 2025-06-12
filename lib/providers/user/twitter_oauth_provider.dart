import 'package:flutter/material.dart';
import '../../services/user/twitter_oauth_service.dart';
import '../../utils/dio_client.dart';
import '../../utils/shared_prefs_util.dart';

class TwitterOauthProvider with ChangeNotifier {
  final TwitterOauthService _twitterOauthService = TwitterOauthService();

  Future<void> signIn() async {
    await _twitterOauthService.launchTwitterAuth();
  }

  // 딥링크 수신 이후 이 메서드 호출
  Future<void> completeServerLogin(BuildContext context, String oauthToken, String oauthVerifier) async {
    try {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
          await _twitterOauthService.completeLogin(oauthToken, oauthVerifier)
      );
      final userId = data['userId'] ?? '';
      final status = data['status'] ?? 'UNKNOWN';
      final name = data['name'] ?? '';

      if (userId.isEmpty) {
        print("❌ 서버 응답에 userId 없음: $data");
        throw Exception("로그인 응답 누락");
      }
      print('🔥 저장 시작 전 : $userId / $status');

      await SharedPrefsUtil.saveTokens(
        accessToken: data['accessToken'] ?? '',
        refreshToken: data['refreshToken'] ?? '',
      );

      await SharedPrefsUtil.saveUserId(userId);
      await SharedPrefsUtil.saveUserStatus(status);
      print('🔥 저장 완료 후');

      Future.microtask(() {
        print('🔥 status: $status / userId: $userId / name: $name');
        if (status == 'REGISTERED') {
          print('🔥 REGISTERED → 홈 이동');
          Navigator.of(navigatorKey.currentContext!).pushReplacementNamed('/home');
        } else {
          print('🔥 NEEDS_INFO → 회원가입 이동');
          Navigator.of(navigatorKey.currentContext!).pushNamed('/twitter_signup', arguments: {
            'userId': userId.toString(),
            'name': name.toString(),
          }).catchError((e) {
            print('❌ Navigator error: $e');
          });
        }
      });
    } catch (e) {
      print('❌ Twitter 로그인 실패: $e');
      rethrow;
    }
  }

  Future<void> completeUserInfo({
    required String userId,
    required String nickName,
    required String email,
    required bool isLocalFlag,
  }) async {
    await _twitterOauthService.completeTwitterUserInfo(
      userId: userId,
      nickName: nickName,
      email: email,
      isLocalFlag: isLocalFlag,
    );
  }
}
