import 'package:flutter/material.dart';
import '../../../models/vote/vote_model.dart';
import '../../../providers/vote/vote_reward_media_provider.dart';
import 'package:provider/provider.dart';

class VoteDetailRewardTab extends StatelessWidget {
  final String voteCode;
  const VoteDetailRewardTab({super.key, required this.voteCode});

  @override
  Widget build(BuildContext context) {
    final rewardMediaList = Provider.of<VoteRewardMediaProvider>(context)
        .getMediaByVoteCode(voteCode);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '보상 이벤트 결과',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: rewardMediaList.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                rewardMediaList[index].voteRewardMediaUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
