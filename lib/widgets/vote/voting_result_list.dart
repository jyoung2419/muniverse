import 'package:flutter/material.dart';
import '../../models/event/main/event_main_vote_artist_model.dart';
import '../../widgets/vote/rank_card.dart';
import '../../widgets/vote/winner_card.dart';

class VotingResultList extends StatelessWidget {
  final List<EventMainVoteArtistModel> artists;

  const VotingResultList({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) {
      return const Center(
        child: Text('데이터 없음', style: TextStyle(color: Colors.white)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WinnerCard(
          name: artists[0].name,
          artistCode: artists[0].name,  // 영어이름으로 추후에 수정 예정
          profileUrl: artists[0].profileUrl,
          votePercent: artists[0].votePercent,
        ),
        const SizedBox(height: 20),
        ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Scrollbar(
            radius: const Radius.circular(8),
            thickness: 6,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(
                  artists.length - 1,
                      (i) => RankCard(
                    index: i + 2,
                    name: artists[i + 1].name,
                    artistCode: artists[i + 1].artistCode,
                    imageUrl: artists[i + 1].profileUrl,
                    votePercent: artists[i + 1].votePercent,
                    icon: Icons.emoji_events,
                    iconColor: i == 0
                        ? Colors.grey
                        : i == 1
                        ? const Color(0xFFCE9505)
                        : Colors.white24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
