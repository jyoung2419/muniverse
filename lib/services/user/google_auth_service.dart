import 'package:google_sign_in/google_sign_in.dart';
import 'dio_client.dart';
import 'package:flutter/material.dart';

Future<void> googleLogin(String idToken, BuildContext context) async {
  final dio = DioClient().dio;
  final response = await dio.post(
    '/api/v1/user/oauth/google',
    data: {'idToken': idToken},
  );

  final data = response.data;
  final status = data['status'];
  final userId = data['userId'];

  if (status == 'REGISTERED') {
    Navigator.pushReplacementNamed(context, '/home');
  } else if (status == 'NEEDS_INFO' || status == 'NEW_USER') {
    Navigator.pushNamed(context, '/google_signup', arguments: userId);
  }
  // } else if (status == 'RECOVERY') {
  //   Navigator.pushNamed(context, '/recovery', arguments: userId);
  // }
}

Future<void> signInWithGoogle(BuildContext context) async {
  final googleUser = await GoogleSignIn().signIn();
  final googleAuth = await googleUser?.authentication;
  final idToken = googleAuth?.idToken;

  if (idToken != null) {
    await googleLogin(idToken, context);
  }
}
