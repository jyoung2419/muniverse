import 'package:flutter/material.dart';
import 'package:twitter_login/twitter_login.dart';
import '../../utils/dio_client.dart';

Future<void> twitterLogin(String oauthToken, String oauthVerifier, BuildContext context) async {
  final dio = DioClient().dio;
  final response = await dio.post(
    '/api/v1/user/oauth/twitter',
    data: {
      'oauthToken': oauthToken,
      'oauthVerifier': oauthVerifier,
    },
  );

  final data = response.data;
  final status = data['status'];
  final userId = data['userId'];

  if (status == 'REGISTERED') {
    Navigator.pushReplacementNamed(context, '/home');
  } else if (status == 'NEEDS_INFO' || status == 'NEW_USER') {
    Navigator.pushNamed(context, '/twitter_signup', arguments: userId);
  }
  // else if (status == 'RECOVERY') {
  //   Navigator.pushNamed(context, '/recovery', arguments: userId);
  // }
}

Future<void> signInWithTwitter(BuildContext context) async {
  final twitterLoginInstance = TwitterLogin(
    apiKey: 'YOUR_CONSUMER_KEY',
    apiSecretKey: 'YOUR_CONSUMER_SECRET',
    redirectURI: 'twittersdk://',
  );

  final authResult = await twitterLoginInstance.login();

  if (authResult.status == TwitterLoginStatus.loggedIn) {
    final oauthToken = authResult.authToken;
    final oauthVerifier = authResult.authTokenSecret;

    if (oauthToken != null && oauthVerifier != null) {
      await twitterLogin(oauthToken, oauthVerifier, context);
    }
  } else {
    print('❌ Twitter 로그인 실패: ${authResult.errorMessage}');
  }
}

