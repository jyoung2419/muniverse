import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/vote/vote_detail_provider.dart';
import '../../../models/vote/vote_reward_model.dart';

class VoteDetailRewardTab extends StatelessWidget {
  final String voteCode;
  const VoteDetailRewardTab({super.key, required this.voteCode});

  @override
  Widget build(BuildContext context) {
    final voteDetail = context.watch<VoteDetailProvider>().voteDetail;
    final List<VoteRewardModel> rewards = voteDetail?.rewards ?? [];

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
          if (rewards.isEmpty)
            const Text('등록된 보상 미디어가 없습니다.',
                style: TextStyle(color: Colors.white54))
          else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: rewards.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  rewards[index].rewardContent,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
