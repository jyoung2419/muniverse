import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/vote/vote_model.dart';
import '../../providers/vote/vote_reward_media_provider.dart';

class VoteDetailInfoTab extends StatelessWidget {
  final VoteModel vote;
  const VoteDetailInfoTab({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final now = DateTime.now();
    final isRunning = now.isAfter(vote.startTime) && now.isBefore(vote.endTime);
    final isUpcoming = now.isBefore(vote.startTime);
    final isEnded = now.isAfter(vote.endTime);
    final remainingDays = vote.endTime.difference(now).inDays;
    final rewardMediaList = context.watch<VoteRewardMediaProvider>().getMediaByVoteCode(vote.voteCode);
    final rewardText = rewardMediaList.isNotEmpty ? rewardMediaList.first.rewardContent : '리워드 정보 없음';

    return RawScrollbar(
      controller: scrollController,
      thumbVisibility: true,
      radius: const Radius.circular(4),
      thickness: 6,
      thumbColor: const Color(0xFFD9D9D9),
      child: SingleChildScrollView(
        controller: scrollController,
        primary: false,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카드
            IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF212225),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          Container(
                            width: 170,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(vote.voteImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isRunning)
                            _buildBadge('진행중', top: 8, left: 8, color: const Color(0xFF2EFFAA), textColor: Colors.black),
                          if (isRunning)
                            _buildBadge('D-DAY $remainingDays', top: 8, left: 55),
                          if (isUpcoming)
                            _buildBadge('투표 예정', top: 8, left: 8, color: const Color(0xFF2EFFAA), textColor: Colors.black),
                          if (isEnded)
                            _buildBadge('종료', top: 8, left: 8, color: Colors.black, textColor: const Color(0xFF2EFFAA)),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vote.voteName,
                                style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(
                              '기간: ${DateFormat('yyyy.MM.dd').format(vote.startTime)} ~ ${DateFormat('yyyy.MM.dd').format(vote.endTime)}',
                              style: const TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                            const SizedBox(height: 6),
                            Text(vote.content,
                                maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.white)),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: const BoxDecoration(color: Color(0xFF121212)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.card_giftcard, size: 14, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text('리워드', style: TextStyle(color: Colors.white, fontSize: 11)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(rewardText, style: const TextStyle(color: Colors.white, fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('보상 이벤트 * 수정예정', style: TextStyle(color: Colors.white)),
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
            const Text(
              '※ 투표는 하루 1회 가능합니다.\n※ 중복 참여 시 투표가 무효 처리될 수 있습니다.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildBadge(String text,
      {required double top, required double left, Color color = Colors.black, Color textColor = Colors.white}) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
