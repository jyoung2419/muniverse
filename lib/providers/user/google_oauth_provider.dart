import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/user/google_oauth_service.dart';
import '../../utils/shared_prefs_util.dart';

class GoogleOauthProvider with ChangeNotifier {
  final _googleOauthService = GoogleOauthService();

  Future<void> signIn(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final idToken = googleAuth?.idToken;

    if (idToken == null) return;

    final data = await _googleOauthService.loginWithGoogle(idToken);

    print('🔥 서버 응답 data: $data');
    final userId = data['userId'];
    final status = data['status'];
    print('🔥 서버 응답 status: $status');

    if (userId != null) {
      await SharedPrefsUtil.saveUserId(userId);
      await SharedPrefsUtil.saveUserStatus(status);

      if (status == 'REGISTERED') {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (status == 'NEEDS_INFO' || status == 'NEW_USER') {
        Navigator.pushNamed(
          context,
          '/google_signup',
          arguments: {
            'email': data['email'],
            'name': data['name'],
          },
        );
      } else {
        print("⚠️ 처리되지 않은 상태: $status");
      }
    } else {
      print("❌ 서버 응답에 userId 없음: $data");
      throw Exception("로그인 응답 누락");
    }
  }
}
