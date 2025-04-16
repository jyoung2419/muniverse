import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAward extends StatelessWidget {
  const HomeAward({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 왼쪽 텍스트 영역
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly M-Chart',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '4월 1주차 주간인기상 투표에 참여하세요',
                style: TextStyle(
                  color: Color(0xFFC2C4C8E0),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        // 오른쪽 링크
        TextButton(
          onPressed: () {
            // TODO: 투표 페이지 이동 로직 추가
          },
          child: const Text(
            '투표하러 가기 >',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
