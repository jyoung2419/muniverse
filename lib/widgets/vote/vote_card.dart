import 'package:flutter/material.dart';
import '../../models/event/detail/event_model.dart';
import '../../models/event/detail/event_vote_model.dart';
import '../../screens/vote/vote_detail_screen.dart';
import '../../utils/vote_text_util.dart';
import '../common/build_badge.dart';
import 'base_vote_card.dart';
import 'vote_card_button.dart';

class VoteCard extends StatelessWidget {
  final EventVoteModel vote;
  final EventModel event;
  final String selectedStatus;
  final VoidCallback onPressed;

  const VoteCard({
    super.key,
    required this.vote,
    required this.event,
    required this.selectedStatus,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final status = selectedStatus.toLowerCase();

    final isRunning = now.isAfter(vote.startTime) && now.isBefore(vote.endTime);
    final isUpcoming = now.isBefore(vote.startTime);
    final isEnded = now.isAfter(vote.endTime);

    final shouldShow = status == 'all' ||
        (status == 'open' && isRunning) ||
        (status == 'before' && isUpcoming) ||
        (status == 'closed' && isEnded);

    if (!shouldShow) return const SizedBox.shrink();

    final labels = VoteTextUtil.getLabelsForEventVote(context, vote);

    late Widget badge;
    if (isRunning && status != 'closed') {
      badge = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BuildBadge(
            text: labels['vote_ongoing']!,
            color: const Color(0xFF2EFFAA),
            textColor: Colors.black,
          ),
          const SizedBox(width: 6),
          BuildBadge(
            text: labels['vote_remaining']!,
            color: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
          ),
        ],
      );
    } else if (isEnded && status != 'open') {
      badge = BuildBadge(
        text: labels['vote_closed']!,
        color: Colors.black,
        textColor: const Color(0xFF2EFFAA),
      );
    } else {
      badge = const SizedBox.shrink();
    }

    return BaseVoteCard(
      badge: badge,
      eventName: event.name,
      voteName: vote.voteName,
      periodText: labels['vote_period']!,
      rewardText: vote.rewards.isNotEmpty ? vote.rewards.join(', ') : labels['vote_reward_empty']!,
      imageUrl: vote.voteImageUrl,
      actionButton: VoteCardButton(
        status: vote.voteStatus,
        voteCode: vote.voteCode,
        eventName: event.name,
        voteText: labels['vote_vote']!,
        resultText: labels['vote_result']!,
        closedText: labels['vote_closed']!,
        upcomingText: labels['vote_upcoming']!,
      ),
    );
  }
}
