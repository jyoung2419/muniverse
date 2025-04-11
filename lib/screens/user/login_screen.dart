import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/muniverse_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const _LoginForm(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Center(
          child: MuniverseText(fontSize: 48),
        ),
        const SizedBox(height: 150),
        const Center(
          child: Text(
            '뮤니버스 계정으로 로그인이나 회원가입해 주세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const _SocialLoginButton(
          text: 'Google로 로그인',
          color: Colors.white,
          textColor: Color(0xFF4A4A4A),
          iconPath: 'assets/svg/google_logo.svg',
        ),
        const _SocialLoginButton(
          text: 'X로 로그인',
          color: Colors.black,
          iconPath: 'assets/svg/x_logo.svg',
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final String? iconPath;

  const _SocialLoginButton({
    required this.text,
    required this.color,
    this.textColor = Colors.white,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (iconPath != null)
              Positioned(
                left: 16,
                child: SvgPicture.asset(
                  iconPath!,
                  width: 20,
                  height: 20,
                ),
              ),
            Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

