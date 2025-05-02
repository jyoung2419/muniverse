import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/vote/vote_main_model.dart';
import '../../screens/vote/vote_detail_screen.dart';

class VoteCardForMain extends StatelessWidget {
  final VoteMainModel vote;
  final String selectedStatus;
  final VoidCallback onPressed;

  const VoteCardForMain({
    super.key,
    required this.vote,
    // required this.event,
    required this.selectedStatus,
    required this.onPressed,
  });

  String getDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('yyyy.MM.dd');
    return '${formatter.format(start)} ~ ${formatter.format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isRunning = now.isAfter(vote.startTime) && now.isBefore(vote.endTime);
    final isUpcoming = now.isBefore(vote.startTime);
    final isEnded = now.isAfter(vote.endTime);
    final rewardText = vote.rewards.isNotEmpty
        ? vote.rewards.map((r) => r.rewardContent).join(', ')
        : '리워드 정보 없음';

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
                        image: NetworkImage(vote.voteImageURL ?? ''),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  if (isRunning && selectedStatus != '진행완료') ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2EFFAA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '진행중',
                          style: TextStyle(color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 52,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                                Icons.access_time_filled, color: Colors.white,
                                size: 12),
                            const SizedBox(width: 3),
                            Text(
                              '남은 투표기간 ${vote.voteRestDay}일',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else
                    if (isUpcoming && selectedStatus != '진행완료' &&
                        selectedStatus != '진행중') ...[
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2EFFAA),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '투표 예정',
                            style: TextStyle(color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ] else
                      if (isEnded && selectedStatus != '진행중') ...[
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '종료',
                              style: TextStyle(color: Color(0xFF2EFFAA),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
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
                    // Text(event.name, style: const TextStyle(
                    //     color: Colors.white, fontSize: 10)),
                    const SizedBox(height: 6),
                    Text(vote.voteName, style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    )
                    ),
                    const SizedBox(height: 6),
                    Text('기간 : ${getDateRange(vote.startTime, vote.endTime)} (KST)',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(color: Color(0xFF121212)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.card_giftcard, size: 14,
                                  color: Colors.white),
                              SizedBox(width: 4),
                              Text('리워드', style: TextStyle(
                                  color: Colors.white, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rewardText,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
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
                              builder: (_) => VoteDetailScreen(voteCode: vote.voteCode, eventName: vote.voteCode ?? ''),  // 수정 필요
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2EFFAA),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(60, 30),
                          elevation: 0,
                        ),
                        child: const Text('투표 하기', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                      )
                          : OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VoteDetailScreen(voteCode: vote.voteCode, eventName: vote.voteCode ?? ''), // 수정 필요
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2EFFAA),
                          side: const BorderSide(color: Color(0xFF2EFFAA), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(60, 30),
                        ),
                        child: Text(
                          isUpcoming ? '투표 예정' : '결과 보기',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2EFFAA),
                          ),
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