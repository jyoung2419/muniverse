import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/user/google_oauth_service.dart';
import '../../utils/shared_prefs_util.dart';

class GoogleOauthProvider with ChangeNotifier {
  final _googleOauthService = GoogleOauthService();

  Future<void> signIn(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: dotenv.env['GOOGLE_CLIENT_ID']
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final idToken = googleAuth?.idToken;
    print("🔥 googleUser: $googleUser");
    print("🔥 idToken: $idToken");

    if (idToken == null) return;

    final data = await _googleOauthService.loginWithGoogle(idToken);

    // ✅ userId 저장 (null 체크 포함)
    final userId = data['userId'];
    if (userId != null) {
      await SharedPrefsUtil.saveUserId(userId);
    } else {
      print("❌ 서버 응답에 userId가 없음: $data");
      throw Exception("userId가 서버 응답에 없습니다.");
    }

    final status = data['status'];

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
    }
  }
}
