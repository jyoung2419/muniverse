import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/vote/vote_model.dart';
import '../../../providers/vote/vote_reward_media_provider.dart';

class VoteDetailInfoTab extends StatelessWidget {
  final VoteModel vote;
  const VoteDetailInfoTab({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    final rewardMediaList = context.watch<VoteRewardMediaProvider>().getMediaByVoteCode(vote.voteCode);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('순위 반영', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          const Text('선호도 조사(투표) 100%', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text('텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공\n텍트입력 공간 입니다.\n부산 원아시에서 가장 인기 있는 여자 아이돌 그룹은 누구?\n투표 참여시 추첨을 통해 원아시아 초대권 제공', style: TextStyle(color: Colors.white)),
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
