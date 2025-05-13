import 'package:flutter/material.dart';
import '../../models/event/main/event_main_vote_artist_model.dart';
import '../../widgets/vote/rank_card.dart';
import '../../widgets/vote/winner_card.dart';
import '../common/translate_text.dart';

class VotingResultList extends StatelessWidget {
  final List<EventMainVoteArtistModel> artists;

  const VotingResultList({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) {
      return const Center(
        child: TranslatedText('데이터 없음', style: TextStyle(color: Colors.white)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ WinnerCard (1등)
        WinnerCard(
          name: artists[0].name,
          profileUrl: artists[0].profileUrl ?? 'assets/images/default_profile.png',
          votePercent: artists[0].votePercent,
        ),
        const SizedBox(height: 20),

        // ✅ 2~5등 RankCard
        if (artists.length > 1)
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
                    (artists.length - 1).clamp(0, 4),  // 최대 4개 (2~5위)
                        (i) => RankCard(
                      index: i + 2,
                      name: artists[i + 1].name,
                      artistCode: '', // ✅ artistCode 없으면 공백 처리 (추후 name이나 다른 필드로 대체 가능)
                      imageUrl: artists[i + 1].profileUrl ?? 'assets/images/default_profile.png',
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
