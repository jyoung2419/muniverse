import 'package:flutter/material.dart';
import '../../models/vote/vote_model.dart';
import '../../providers/vote/vote_reward_media_provider.dart';
import 'package:provider/provider.dart';

class VoteDetailRewardTab extends StatelessWidget {
  final VoteModel vote;
  const VoteDetailRewardTab({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    final rewardMediaList = Provider.of<VoteRewardMediaProvider>(context)
        .getMediaByVoteCode(vote.voteCode);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '보상 이벤트',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rewardMediaList.length,
              itemBuilder: (context, index) => Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.only(right: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  rewardMediaList[index].voteRewardMediaUrl,
                  width: 200,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}