import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../vote/vote_home_screen.dart';

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
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Weekly ',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Transform.translate(
                        offset: const Offset(1, -2),
                        child: SvgPicture.asset(
                          'assets/svg/m_logo.svg',
                          height: 26,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '-Pick',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VoteHomeScreen()),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '투표하러 가기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(top: 1.5), // 숫자는 상황에 맞게 조절
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
