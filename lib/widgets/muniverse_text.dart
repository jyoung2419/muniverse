import 'package:flutter/material.dart';

class MuniverseText extends StatelessWidget {
  final double fontSize;

  const MuniverseText({super.key, this.fontSize = 32}); // 기본값 32

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Color(0xFF30CEFD), Color(0xFF8439FA)],
        ).createShader(bounds);
      },
      child: Text(
        'MUNIVERSE',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          fontSize: fontSize,
          height: 1.0,
          letterSpacing: 0.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
