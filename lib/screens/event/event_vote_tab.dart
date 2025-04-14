import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vote_provider.dart';
import '../../models/vote_model.dart';

class EventVoteTab extends StatelessWidget {
  const EventVoteTab({super.key});

  @override
  Widget build(BuildContext context) {
    final votes = Provider.of<VoteProvider>(context).votes;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: votes.length > 6 ? 6 : votes.length,
      itemBuilder: (context, index) {
        final vote = votes[index];
        return VoteCard(vote: vote);
      },
    );
  }
}

class VoteCard extends StatelessWidget {
  final VoteModel vote;

  const VoteCard({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(vote.imageUrl, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vote.topic, style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  '${vote.artistName}\n(${vote.artistNameKr})',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.emoji_events, color: Colors.purple, size: 18),
                        SizedBox(width: 4),
                      ],
                    ),
                    Text('${vote.voteRate.toInt()}%',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '총 득표수 ${vote.totalVotes}',
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
