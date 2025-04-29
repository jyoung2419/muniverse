import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../providers/vote/vote_detail_provider.dart';
import '../../../providers/vote/vote_reward_media_provider.dart';

class VoteDetailInfoTab extends StatelessWidget {
  final String voteCode;
  const VoteDetailInfoTab({super.key, required this.voteCode});

  @override
  Widget build(BuildContext context) {
    final rewardMediaList = context.watch<VoteRewardMediaProvider>().getMediaByVoteCode(voteCode);
    final content = context.watch<VoteDetailProvider>().voteDetail?.detailContent.content ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Html(
            data: content,
            style: {
              "body": Style(
                color: Colors.white,
              ),
              "li": Style(
                color: Colors.white,
              ),
              "p": Style(
                color: Colors.white,
              ),
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rewardMediaList.length,
              itemBuilder: (context, index) => Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.only(right: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Image.asset(
                  rewardMediaList[index].voteRewardMediaUrl,
                  width: 200,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
