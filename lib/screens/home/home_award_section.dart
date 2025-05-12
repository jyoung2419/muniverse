import 'package:flutter/material.dart';
import '../../models/event/main/event_main_vote_model.dart';
import '../../utils/vote_text_util.dart';
import '../../widgets/vote/voting_progress_list.dart';
import '../../widgets/vote/voting_result_list.dart';

class HomeAwardSection extends StatelessWidget {
  final EventMainVoteModel vote;

  const HomeAwardSection({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    final labels = VoteTextUtil.getLabelsForMainVote(context, vote);

    return Column(
      children: [
        if (vote.ongoing)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: vote.voteImageURL != null
                    ? Image.network(
                  vote.voteImageURL!,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                )
                    : Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey,
                  child: Center(
                    child: Text(labels['vote_reward_empty']!, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2EFFAA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        labels['vote_ongoing']!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_filled, color: Colors.white, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            labels['vote_remaining']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        vote.ongoing
            ? VotingProgressList(artists: vote.topArtists)
            : VotingResultList(artists: vote.topArtists),
      ],
    );
  }
}
