import 'package:flutter/material.dart';
import '../../models/event/detail/event_model.dart';
import '../../models/event/detail/event_vote_model.dart';
import '../../screens/vote/vote_detail_screen.dart';
import '../../utils/vote_text_util.dart';
import '../common/translate_text.dart';

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


    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF212225),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  Container(
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(vote.voteImageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  if (isRunning && status != 'closed') ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 160),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2EFFAA),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                labels['vote_ongoing']!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
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
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (isEnded && status != 'open') ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          labels['vote_closed']!,
                          style: const TextStyle(color: Color(0xFF2EFFAA), fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 12, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText(event.name, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    const SizedBox(height: 6),
                    TranslatedText(vote.voteName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(labels['vote_period']!, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(color: Color(0xFF121212)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.card_giftcard, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(labels['vote_reward']!, style: const TextStyle(color: Colors.white, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          TranslatedText(vote.rewards.isNotEmpty ? vote.rewards.join(', ') : labels['vote_reward_empty']!, style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: isRunning
                          ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VoteDetailScreen(voteCode: vote.voteCode, eventName: event.name),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2EFFAA),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(60, 30),
                          elevation: 0,
                        ),
                        child: Text(labels['vote_vote']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                      )
                          : OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VoteDetailScreen(voteCode: vote.voteCode, eventName: event.name),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2EFFAA),
                          side: const BorderSide(color: Color(0xFF2EFFAA), width: 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(60, 30),
                        ),
                        child: Text(
                          isUpcoming ? labels['vote_upcoming']! : labels['vote_result']!,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF2EFFAA)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
