import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/event/main/event_main_vote_model.dart';
import '../../widgets/common/translate_text.dart';
import '../vote/vote_detail_screen.dart';

class HomeAward extends StatelessWidget {
  final EventMainVoteModel? vote;

  const HomeAward({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 왼쪽 텍스트 영역
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/svg/mpick.png',
                height: 36,
              ),
              const SizedBox(height: 10),
              if (vote != null)
                TranslatedText(
                  '${vote!.voteName} 투표에 참여하세요',
                  style: const TextStyle(
                    color: Color(0xC2C4C8E0),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ),
        // 오른쪽 링크
        if (vote != null)
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VoteDetailScreen(
                    voteCode: vote!.voteCode,
                    eventName: 'Weekly M-Pick',
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                TranslatedText(
                  '투표하러 가기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Padding(
                  padding: EdgeInsets.only(top: 1.5),
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
