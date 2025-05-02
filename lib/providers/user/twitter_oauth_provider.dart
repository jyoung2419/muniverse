import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/user/twitter_oauth_service.dart';
import 'package:muniverse_app/utils/shared_prefs_util.dart';

class TwitterOauthProvider with ChangeNotifier {
  final TwitterOauthService _twitterOauthService = TwitterOauthService();
  StreamSubscription? _sub;

  Future<void> signIn(BuildContext context) async {
    try {
      // 1단계: Twitter 인증 URL 받아오기
      final authUrl = await _twitterOauthService.initiateTwitterLogin();

      // 2단계: URL 열기 (외부 브라우저)
      if (await canLaunchUrl(Uri.parse(authUrl))) {
        await launchUrl(Uri.parse(authUrl), mode: LaunchMode.externalApplication);
      }

      // 3단계: uni_links로 콜백 URI 수신 대기
      _sub = uriLinkStream.listen((Uri? uri) async {
        if (uri != null && uri.scheme == 'muniverse_app') {
          final oauthToken = uri.queryParameters['oauth_token'];
          final oauthVerifier = uri.queryParameters['oauth_verifier'];

          if (oauthToken != null && oauthVerifier != null) {
            // 4단계: 서버에 전달하여 로그인 처리
            final data = await _twitterOauthService.loginWithTwitter(
              oauthToken: oauthToken,
              oauthVerifier: oauthVerifier,
            );

            final userId = data['userId'];
            final status = data['status'];

            if (userId != null) {
              await SharedPrefsUtil.saveUserId(userId);
              await SharedPrefsUtil.saveUserStatus(status);

              if (status == 'REGISTERED') {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                Navigator.pushNamed(context, '/twitter_signup', arguments: {
                  'userId': userId,
                  'nickname': data['nickname'],
                });
              }
            } else {
              print("❌ 서버 응답에 userId 없음: $data");
              throw Exception("로그인 응답 누락");
            }
            _sub?.cancel(); // 콜백 받은 후 스트림 종료
          }
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

  void disposeStream() {
    _sub?.cancel();
  }
}
